param([Parameter(Mandatory=$true)][string]$ProjectId)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$jsonPath = Join-Path $root 'android/app/google-services.json'
$optionsPath = Join-Path $root 'lib/firebase_options.dart'
if (!(Test-Path -LiteralPath $jsonPath) -or !(Test-Path -LiteralPath $optionsPath)) {
  throw 'Faltam os arquivos oficiais google-services.json e/ou firebase_options.dart.'
}
$config = Get-Content -LiteralPath $jsonPath -Raw | ConvertFrom-Json
if ($config.project_info.project_id -cne $ProjectId) { throw 'google-services.json pertence a outro projeto.' }
$clients = @($config.client | Where-Object {
  $_.client_info.android_client_info.package_name -ceq 'br.edu.mapa.mapa_locais'
})
if ($clients.Count -ne 1) { throw 'Não há exatamente um cliente para o pacote Android esperado.' }
$options = Get-Content -LiteralPath $optionsPath -Raw
$android = [regex]::Match($options, '(?s)static const FirebaseOptions android\s*=\s*FirebaseOptions\((.*?)\);')
if (!$android.Success) { throw 'Opções Android não encontradas no arquivo FlutterFire.' }
foreach ($entry in @(
  @{ Name = 'projectId'; Value = $ProjectId },
  @{ Name = 'appId'; Value = $clients[0].client_info.mobilesdk_app_id },
  @{ Name = 'messagingSenderId'; Value = [string]$config.project_info.project_number }
)) {
  $pattern = $entry.Name + ':\s*[''"'']' + [regex]::Escape($entry.Value) + '[''"'']'
  if ($android.Groups[1].Value -notmatch $pattern) { throw "Configuração divergente: $($entry.Name)." }
}
$settings = Get-Content (Join-Path $root 'android/settings.gradle.kts') -Raw
$app = Get-Content (Join-Path $root 'android/app/build.gradle.kts') -Raw
if ($settings -notmatch 'id\("com\.google\.gms\.google-services"\)\s+version' -or
    $app -notmatch 'id\("com\.google\.gms\.google-services"\)') {
  throw 'Plugin Google Services pendente nos arquivos Gradle Kotlin. Revise antes de habilitar o bootstrap.'
}
Write-Host "Projeto, app Android e plugin Google Services consistentes: $ProjectId. Nenhuma credencial exibida."
