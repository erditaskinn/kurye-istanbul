param([string]$GodotPath='D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path -Parent $PSScriptRoot
$previousProfile=$env:APPDATA
try {
 $env:APPDATA=Join-Path $env:TEMP ('kurye-r1-'+[guid]::NewGuid().ToString('N'))
 New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
 foreach ($scriptName in @('measure_r1','measure_r1_io')) {
  $logPath=Join-Path $projectRoot "build/$scriptName.log"
  & $GodotPath --headless --path $projectRoot --script "res://tools/$scriptName.gd" *> $logPath
  Get-Content -LiteralPath $logPath -Tail 8
  if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $logPath -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) {throw "R1 failed: $scriptName"}
 }
} finally {$env:APPDATA=$previousProfile}
