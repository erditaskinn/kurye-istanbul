param([string]$GodotPath='D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'build/r6/baseline/Main.tscn'))) {throw 'R6 requires the archived frozen0.22source; do not regenerate it from current scripts.'}
$manifestPath=Join-Path $projectRoot 'build/r6/baseline/frozen-sha256.json'
if (-not (Test-Path -LiteralPath $manifestPath)) {throw 'R6 frozen-source manifest missing'}
$manifest=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
foreach ($entry in $manifest.PSObject.Properties) {
 $filePath=Join-Path $projectRoot ("build/r6/baseline/"+$entry.Name)
 if ((Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.Value) {throw "R6 baseline hash mismatch: $($entry.Name)"}
}
$previousProfile=$env:APPDATA
try {
 foreach ($scriptName in @('verify_r6','capture_r6_compare')) {
  $env:APPDATA=Join-Path $env:TEMP ('kurye-r6-'+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
  $logPath=Join-Path $projectRoot "build/r6/$scriptName.log"
  $arguments=@('--path',$projectRoot,'--script',"res://tools/$scriptName.gd")
  if ($scriptName -eq 'verify_r6') {$arguments=@('--headless')+$arguments}
  & $GodotPath @arguments *> $logPath
  Get-Content -LiteralPath $logPath -Tail 3
  if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $logPath -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) {throw "R6 failed: $scriptName"}
 }
} finally {$env:APPDATA=$previousProfile}
