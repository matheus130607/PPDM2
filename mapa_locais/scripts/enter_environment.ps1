# Execute com dot-sourcing: . ./scripts/enter_environment.ps1
# Estas variáveis afetam somente o terminal atual, nunca o PATH global.
$mapaProjectRoot = Split-Path $PSScriptRoot -Parent
$mapaTools = (Get-Content (Join-Path $mapaProjectRoot '.tooling_path.txt') -Raw).Trim()
if (!(Test-Path -LiteralPath $mapaTools)) { throw 'Pasta de ferramentas locais indisponível.' }
$mapaJava = @(Get-ChildItem (Join-Path $mapaTools 'java') -Directory)
if ($mapaJava.Count -ne 1) { throw 'Instalação Java local ausente ou ambígua.' }
$env:JAVA_HOME = $mapaJava[0].FullName
$env:ANDROID_HOME = Join-Path $mapaTools 'android-sdk'
$env:PUB_CACHE = Join-Path $mapaTools 'pub-cache'
$env:PATH = "$env:JAVA_HOME\bin;$mapaTools\flutter\bin;$mapaTools\node_modules\.bin;$mapaTools\pub-cache\bin;$env:ANDROID_HOME\platform-tools;$env:PATH"
Write-Host 'Ferramentas locais disponíveis neste terminal.'
