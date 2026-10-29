param([string]$GodotPath='D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path -Parent $PSScriptRoot
foreach ($file in @('main.gd','economy.gd','dispatch.gd','save_store.gd','isolated-main.gd','isolated-dispatch.gd')) {
 if (-not (Test-Path -LiteralPath (Join-Path $projectRoot "build/r4/baseline/$file"))) {throw 'R4 frozen0.20baseline missing; do not replace it with current source.'}
}
$previousProfile=$env:APPDATA
try {
 foreach ($scriptName in @('measure_r4','verify_r4_migration')) {
  $env:APPDATA=Join-Path $env:TEMP ('kurye-r4-'+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
  $logPath=Join-Path $projectRoot "build/r4/$scriptName.log"
  & $GodotPath --headless --path $projectRoot --script "res://tools/$scriptName.gd" *> $logPath
  Get-Content -LiteralPath $logPath -Tail 8
  if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $logPath -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) {throw "R4 failed: $scriptName"}
 }
} finally {$env:APPDATA=$previousProfile}
