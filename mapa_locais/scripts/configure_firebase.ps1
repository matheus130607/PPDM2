param(
  [Parameter(Mandatory=$true)][string]$ProjectId,
  [string]$ToolingPath,
  [string]$FlutterSdkPath,
  [switch]$ApproveRemoteRegistration,
  [switch]$UseExistingAndroidApp
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
$oldPath = $env:PATH
$oldCache = $env:PUB_CACHE
try {
  if (!$ApproveRemoteRegistration -and !$UseExistingAndroidApp) {
    throw 'O FlutterFire pode registrar um app remoto. Após aprovação do proprietário, use -ApproveRemoteRegistration.'
  }
  if ($ProjectId -notmatch '^[a-z][a-z0-9-]{4,28}[a-z0-9]$') { throw 'Informe o Project ID real, não o nome de exibição.' }
  if (!$ToolingPath) {
    $ToolingPath = Join-Path $projectRoot '.tooling'
    if (!(Test-Path -LiteralPath $ToolingPath) -and (Test-Path -LiteralPath '.tooling_path.txt')) {
      $ToolingPath = (Get-Content -LiteralPath '.tooling_path.txt' -Raw).Trim()
    }
  }
  $firebaseCli = Join-Path $ToolingPath 'node_modules\.bin\firebase.cmd'
  $flutterfireCli = Join-Path $ToolingPath 'pub-cache\bin\flutterfire.bat'
  foreach ($tool in @($firebaseCli, $flutterfireCli)) {
    if (!(Test-Path -LiteralPath $tool)) { throw "Ferramenta ausente: $tool. Informe -ToolingPath com a instalação existente." }
  }
  if (!$FlutterSdkPath -and (Test-Path -LiteralPath 'android/local.properties')) {
    $sdkLine = Get-Content 'android/local.properties' | Where-Object { $_ -match '^flutter\.sdk=' } | Select-Object -First 1
    if ($sdkLine) { $FlutterSdkPath = ($sdkLine -replace '^flutter\.sdk=', '') -replace '\\\\', '\' }
  }
  if ($FlutterSdkPath) {
    if (!(Test-Path -LiteralPath (Join-Path $FlutterSdkPath 'bin\flutter.bat'))) {
      throw 'Flutter SDK não encontrado. Informe -FlutterSdkPath com a instalação atual.'
    }
    $env:PATH = "$FlutterSdkPath\bin;$oldPath"
  }
  $env:PATH = "$ToolingPath\node_modules\.bin;$ToolingPath\pub-cache\bin;$env:PATH"
  $env:PUB_CACHE = "$ToolingPath\pub-cache"
  if (!(Get-Command dart -ErrorAction SilentlyContinue) -or !(Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter e Dart precisam estar disponíveis antes da configuração.'
  }
  $gradle = Get-Content 'android/app/build.gradle.kts' -Raw
  if ($gradle -notmatch 'applicationId\s*=\s*"br\.edu\.mapa\.mapa_locais"' -or
      $gradle -notmatch 'namespace\s*=\s*"br\.edu\.mapa\.mapa_locais"') {
    throw 'O pacote Android difere de br.edu.mapa.mapa_locais.'
  }
  # Somente leitura: exige login prévio e confirma o projeto antes de registrar.
  $projectsOutput = & $firebaseCli projects:list --json --non-interactive
  if ($LASTEXITCODE -ne 0) { throw 'Execute scripts/login_firebase.ps1 e confirme acesso ao projeto.' }
  $projectsResponse = ($projectsOutput -join "`n") | ConvertFrom-Json
  $selected = @($projectsResponse.result | Where-Object { $_.projectId -eq $ProjectId })
  if ($selected.Count -ne 1) { throw 'Project ID não encontrado entre os projetos acessíveis.' }
  if ($selected[0].displayName -in @('Cadastro de Alunos', 'Sistema de presença SENAI')) {
    throw 'Este projeto está fora do escopo e não pode ser modificado.'
  }
  Write-Host "Destino confirmado: $($selected[0].displayName) ($ProjectId)."
  if ($UseExistingAndroidApp) {
    $localConfigPath = Join-Path $projectRoot 'android/app/google-services.json'
    if (!(Test-Path -LiteralPath $localConfigPath)) { throw 'Arquivo oficial necessário para identificar o app existente.' }
    $localConfig = Get-Content -LiteralPath $localConfigPath -Raw | ConvertFrom-Json
    if ($localConfig.project_info.project_id -cne $ProjectId) { throw 'Arquivo oficial pertence a outro projeto.' }
    $localClients = @($localConfig.client | Where-Object { $_.client_info.android_client_info.package_name -ceq 'br.edu.mapa.mapa_locais' })
    if ($localClients.Count -ne 1) { throw 'Pacote esperado ausente ou ambíguo no arquivo oficial.' }
    $appsOutput = & $firebaseCli apps:list ANDROID --project=$ProjectId --json --non-interactive
    if ($LASTEXITCODE -ne 0) { throw 'Não foi possível confirmar o app existente remotamente.' }
    $apps = (($appsOutput -join "`n") | ConvertFrom-Json).result
    if (@($apps | Where-Object { $_.appId -ceq $localClients[0].client_info.mobilesdk_app_id }).Count -ne 1) {
      throw 'App oficial não encontrado no projeto. Não criar um registro novo sem aprovação.'
    }
    Write-Host 'App Android existente confirmado; configurar somente a plataforma Android.'
  }
  & $flutterfireCli configure --project=$ProjectId --platforms=android --android-package-name=br.edu.mapa.mapa_locais --yes
  if ($LASTEXITCODE -ne 0) { throw 'FlutterFire não concluiu a configuração.' }
  & (Join-Path $PSScriptRoot 'verify_firebase.ps1') -ProjectId $ProjectId
  $bootstrap = @(
    "import 'package:firebase_core/firebase_core.dart';",
    "import 'firebase_options.dart';",
    '',
    'Future<void> initializeBackend() async {',
    '  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);',
    '}'
  ) -join "`n"
  $bootstrap | Set-Content -LiteralPath 'lib/firebase_bootstrap.dart' -Encoding utf8
  & dart format lib/firebase_options.dart lib/firebase_bootstrap.dart
  if ($LASTEXITCODE -ne 0) { throw 'Não foi possível formatar a configuração.' }
  Write-Host 'Configuração local verificada. Banco, provedor, autorizações e publicação das regras exigem etapas próprias.'
} finally {
  $env:PATH = $oldPath
  $env:PUB_CACHE = $oldCache
  Pop-Location
}
