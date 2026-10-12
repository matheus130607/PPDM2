$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'enter_environment.ps1')
Write-Host 'Leia os termos apresentados. Aceite com y somente se concordar.'
Write-Host 'Não há aceitação automática neste script.'
& (Join-Path $env:ANDROID_HOME 'cmdline-tools\latest\bin\sdkmanager.bat') --sdk_root=$env:ANDROID_HOME --licenses
if ($LASTEXITCODE -ne 0) { throw 'A revisão de licenças não foi concluída.' }
Write-Host 'Informe ao Codex quando a revisão estiver concluída.'
Read-Host 'Pressione Enter para fechar'
