param([Parameter(Mandatory=$true)][string]$ProjectId, [string]$ToolingPath)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
$oldPath = $env:PATH
$oldCache = $env:PUB_CACHE
try {
  if (!$ToolingPath) {
    $ToolingPath = Join-Path $projectRoot '.tooling'
    if (!(Test-Path -LiteralPath $ToolingPath) -and (Test-Path -LiteralPath '.tooling_path.txt')) {
      $ToolingPath = (Get-Content -LiteralPath '.tooling_path.txt' -Raw).Trim()
    }
  }
  $ToolingPath = (Resolve-Path -LiteralPath $ToolingPath).Path
  $env:PATH = "$ToolingPath\node_modules\.bin;$ToolingPath\pub-cache\bin;$oldPath"
  $env:PUB_CACHE = "$ToolingPath\pub-cache"
  & firebase --version
  if ($LASTEXITCODE -ne 0) { throw 'Firebase CLI indisponível. Veja a instalação local no README.' }
  Write-Host 'Antes de configurar, conclua scripts/login_firebase.ps1 se ainda não houver uma conta autorizada na CLI.'
  $projectsResult = & firebase projects:list --json 2>$null | Out-String
  if ($LASTEXITCODE -ne 0) { throw 'Autenticação não concluída. Execute scripts/login_firebase.ps1.' }
  $projectsResponse = $projectsResult | ConvertFrom-Json
  if ($projectsResponse.status -ne 'success') { throw 'Não foi possível verificar a conta autenticada.' }
  & flutterfire configure --project=$ProjectId --platforms=android
  if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath 'lib\firebase_options.dart')) { throw 'FlutterFire não gerou a configuração oficial.' }
  @'
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> initializeBackend() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
'@ | Set-Content -LiteralPath 'lib\firebase_bootstrap.dart' -Encoding utf8
  & dart format lib/firebase_bootstrap.dart
  Write-Host 'Configuração local concluída. Configure Firestore, conta e regras antes de executar.'
} finally {
  $env:PATH = $oldPath
  $env:PUB_CACHE = $oldCache
  Pop-Location
}
