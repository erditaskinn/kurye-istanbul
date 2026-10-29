param([string]$GodotPath='D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path -Parent $PSScriptRoot
$baseline=Join-Path $projectRoot 'build/r2/baseline-main-0.18.gd'
if (-not (Test-Path -LiteralPath $baseline)) {throw 'R2 requires the archived original 0.18 baseline at build/r2/baseline-main-0.18.gd; do not substitute current main.gd.'}
if ((Get-FileHash -LiteralPath $baseline -Algorithm SHA256).Hash -ne '915F0854398D54E981FC87E64CF4CBC141CC3D0ED5AEB731C492EB53CDC89B13') {throw 'R2 baseline hash mismatch'}
$previousProfile=$env:APPDATA
try {
 $env:APPDATA=Join-Path $env:TEMP ('kurye-r2-'+[guid]::NewGuid().ToString('N'))
 New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
 $logPath=Join-Path $projectRoot 'build/r2/verification.log'
 & $GodotPath --headless --path $projectRoot --script res://tools/measure_r2.gd *> $logPath
 Get-Content -LiteralPath $logPath -Tail 8
 if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $logPath -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) {throw 'R2 verification failed'}
} finally {$env:APPDATA=$previousProfile}
