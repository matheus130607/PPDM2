// Optional administrative routine. Never runs on app startup.
const path = require('node:path');
const fs = require('node:fs');
const projectIndex = process.argv.indexOf('--project');
const projectId = projectIndex < 0 ? null : process.argv[projectIndex + 1];
const records = JSON.parse(fs.readFileSync(path.join(__dirname, '../data/locais_iniciais.json'), 'utf8'));
const fields = ['nome', 'categoria', 'cidade', 'avaliacao', 'distancia', 'horario', 'descricao', 'favorito'];
const ids = new Set();
for (const {id, ...record} of records) {
  const valid = typeof id === 'string' && /^[a-z0-9-]+$/.test(id) && !ids.has(id)
    && Object.keys(record).length === fields.length && fields.every(field => Object.hasOwn(record, field))
    && ['nome', 'categoria', 'cidade', 'horario', 'descricao'].every(field => typeof record[field] === 'string')
    && record.nome.length > 0 && record.nome.length <= 120
    && record.categoria.length > 0 && record.categoria.length <= 120
    && ['São Paulo', 'Campinas', 'Jundiaí'].includes(record.cidade)
    && typeof record.avaliacao === 'number' && Number.isFinite(record.avaliacao) && record.avaliacao >= 0 && record.avaliacao <= 5
    && typeof record.distancia === 'number' && Number.isFinite(record.distancia) && record.distancia >= 0
    && record.horario.length <= 120 && record.descricao.length <= 2000 && typeof record.favorito === 'boolean';
  if (!valid) { console.error('Dados iniciais inválidos; nenhuma escrita iniciada.'); process.exit(1); }
  ids.add(id);
}
if (process.argv.includes('--dry-run')) {
  console.log(`Validação local: ${records.length} documentos válidos para locais; IDs únicos; nenhuma conexão remota.`);
  process.exit(0);
}
if (!projectId || !process.argv.includes('--approve-remote-seed')) {
  console.error('Uso: node scripts/seed.cjs --project PROJECT_ID_REAL --approve-remote-seed');
  console.error('Requer aprovação explícita para carga remota e Application Default Credentials reais.');
  process.exit(1);
}
if (process.env.FIRESTORE_EMULATOR_HOST) {
  console.error('Este comando foi preparado para carga remota aprovada. Remova a variável do emulator para evitar destino ambíguo.');
  process.exit(1);
}
const root = path.join(__dirname, '..');
const pointer = path.join(root, '.tooling_path.txt');
const tooling = process.env.MAPA_TOOLING_PATH || (fs.existsSync(pointer) ? fs.readFileSync(pointer, 'utf8').trim() : path.join(root, '.tooling'));
const localRequire = require('node:module').createRequire(path.join(tooling, 'package.json'));
const {initializeApp, applicationDefault} = localRequire('firebase-admin/app');
const {getFirestore} = localRequire('firebase-admin/firestore');
let cliAccount;
let cliAuth;
if (process.argv.includes('--use-firebase-cli-login')) {
  // Reuse the owner's existing OAuth login, never print or export its tokens.
  // Internal CLI API verified against the locally pinned firebase-tools 15.33.0.
  const config = JSON.parse(fs.readFileSync(path.join(root, 'android/app/google-services.json'), 'utf8'));
  if (config.project_info.project_id !== projectId) {
    console.error('Projeto da carga difere do aplicativo configurado. Nenhuma escrita iniciada.');
    process.exit(1);
  }
  const auth = localRequire('firebase-tools/lib/auth');
  const account = auth.getGlobalDefaultAccount();
  if (!account?.tokens?.refresh_token) {
    console.error('Login Firebase CLI ausente. Execute scripts/login_firebase.ps1.');
    process.exit(1);
  }
  cliAccount = account;
  cliAuth = auth;
}
let db;
if (!cliAccount) {
  initializeApp({credential: applicationDefault(), projectId});
  db = getFirestore();
}
async function createUsingCliLogin(id, record) {
  const tokens = await cliAuth.getAccessToken(cliAccount.tokens.refresh_token, [
    'https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/firebase',
  ]);
  if (!tokens.access_token) throw new Error('Sessão OAuth inválida.');
  const fields = Object.fromEntries(Object.entries(record).map(([key, value]) => [key,
    typeof value === 'boolean' ? {booleanValue: value}
      : typeof value === 'number' ? {doubleValue: value} : {stringValue: value},
  ]));
  const url = `https://firestore.googleapis.com/v1/projects/${encodeURIComponent(projectId)}/databases/(default)/documents/locais?documentId=${encodeURIComponent(id)}`;
  // Atomic create with a deterministic ID; 409 preserves existing documents.
  const response = await fetch(url, {
    method: 'POST',
    headers: {Authorization: `Bearer ${tokens.access_token}`, 'Content-Type': 'application/json'},
    body: JSON.stringify({fields}),
  });
  if (response.status === 409) return false;
  if (response.status !== 200) throw new Error(`Carga recusada: HTTP ${response.status}.`);
  return true;
}
(async () => {
  let created = 0;
  for (const {id, ...record} of records) {
    const inserted = cliAccount ? await createUsingCliLogin(id, record) : await db.runTransaction(async tx => {
      const ref = db.collection('locais').doc(id);
      if ((await tx.get(ref)).exists) return false;
      tx.create(ref, record); return true;
    });
    if (inserted) created++;
  }
  console.log(`Destino: ${projectId}; criados: ${created}; existentes preservados: ${records.length - created}.`);
})().catch(() => { console.error('Carga não concluída. Verifique credenciais, projeto e permissões. Reexecutar preserva registros já criados.'); process.exitCode = 1; });
