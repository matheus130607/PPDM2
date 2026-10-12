// Read only by default. Authorization creation requires --approve-authorization.
// Does not print email, password or OAuth tokens.
const fs = require('node:fs');
const path = require('node:path');
const root = path.join(__dirname, '..');
const projectId = 'mapa-de-locais-c0801';
const uid = process.argv[2];
if (!uid || !/^[A-Za-z0-9_-]{1,128}$/.test(uid)) {
  console.error('Informe somente o UID da conta de teste.');
  process.exit(1);
}
if (process.env.FIRESTORE_EMULATOR_HOST || process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  console.error('Destino ambíguo: variáveis de emulador presentes.');
  process.exit(1);
}
const config = JSON.parse(fs.readFileSync(path.join(root, 'android/app/google-services.json'), 'utf8'));
if (config.project_info.project_id !== projectId) {
  console.error('Projeto configurado divergente.');
  process.exit(1);
}
const tooling = fs.readFileSync(path.join(root, '.tooling_path.txt'), 'utf8').trim();
const localRequire = require('node:module').createRequire(path.join(tooling, 'package.json'));
const auth = localRequire('firebase-tools/lib/auth');
const {initializeApp} = localRequire('firebase-admin/app');
const {getAuth} = localRequire('firebase-admin/auth');
const account = auth.getGlobalDefaultAccount();
if (!account?.tokens?.refresh_token) {
  console.error('Login Firebase CLI indisponível.');
  process.exit(1);
}
initializeApp({projectId, credential: {
  async getAccessToken() {
    const tokens = await auth.getAccessToken(account.tokens.refresh_token, [
      'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/firebase',
    ]);
    const lifetime = Number.isFinite(tokens.expires_at)
      ? Math.floor((tokens.expires_at - Date.now()) / 1000) : tokens.expires_in;
    if (!tokens.access_token || !Number.isFinite(lifetime) || lifetime <= 0) throw new Error('Sessão inválida.');
    return {access_token: tokens.access_token, expires_in: lifetime};
  },
}});
(async () => {
  const user = await getAuth().getUser(uid);
  const tokens = await auth.getAccessToken(account.tokens.refresh_token, [
    'https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/firebase',
  ]);
  const base = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents`;
  const headers = {Authorization: `Bearer ${tokens.access_token}`, 'Content-Type': 'application/json'};
  const response = await fetch(`${base}/authorized_users/${uid}`, {headers});
  if (response.status !== 200 && response.status !== 404) throw Object.assign(new Error('Consulta recusada.'), {code: `http/${response.status}`});
  let authorizationExists = response.status === 200;
  if (!authorizationExists && process.argv.includes('--approve-authorization')) {
    if (user.disabled || !user.providerData.some(provider => provider.providerId === 'password')) {
      throw Object.assign(new Error('Conta de teste inválida.'), {code: 'auth/invalid-test-user'});
    }
    const created = await fetch(`${base}/authorized_users?documentId=${uid}`, {
      method: 'POST', headers,
      body: JSON.stringify({fields: {observacao: {stringValue: 'Conta de teste do Mapa de Locais'}}}),
    });
    if (created.status !== 200 && created.status !== 409) throw Object.assign(new Error('Autorização recusada.'), {code: `http/${created.status}`});
    const verified = await fetch(`${base}/authorized_users/${uid}`, {headers});
    if (verified.status !== 200) throw Object.assign(new Error('Autorização não confirmada.'), {code: `http/${verified.status}`});
    authorizationExists = true;
  }
  console.log(JSON.stringify({projectId, uid: user.uid, disabled: user.disabled,
    providers: user.providerData.map(provider => provider.providerId),
    authorizationExists}, null, 2));
})().catch(error => {
  console.error('Consulta administrativa não concluída; código:', error.code || 'indisponível');
  process.exitCode = 1;
});
