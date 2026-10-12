param([string]$ToolingPath, [switch]$NoLocalhost)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
if (!$ToolingPath) {
  $ToolingPath = Join-Path $projectRoot '.tooling'
  $pointer = Join-Path $projectRoot '.tooling_path.txt'
  if (!(Test-Path -LiteralPath $ToolingPath) -and (Test-Path -LiteralPath $pointer)) {
    $ToolingPath = (Get-Content -LiteralPath $pointer -Raw).Trim()
  }
}
$firebaseCli = Join-Path $ToolingPath 'node_modules\.bin\firebase.cmd'
if (!(Test-Path -LiteralPath $firebaseCli)) {
  throw 'Firebase CLI ausente. Informe -ToolingPath com a instalação existente; consulte docs/FIREBASE_SETUP.md.'
}
Write-Host 'Conclua o login no navegador oficial. Não envie senha, token ou código pelo chat.'
if ($NoLocalhost) { & $firebaseCli login --interactive --no-localhost } else { & $firebaseCli login --interactive }
if ($LASTEXITCODE -ne 0) { throw 'Login Firebase não concluído.' }
& $firebaseCli login:list
if ($LASTEXITCODE -ne 0) { throw 'Não foi possível verificar a sessão Firebase.' }
