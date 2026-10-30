param([string]$GodotPath='D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path -Parent $PSScriptRoot
$originalProfile=$env:APPDATA
try {
 foreach ($test in @('playtest_fixes','progression','motivation','specialization','company_model','company_layout','investment_preview','economy_v7','game_feedback','transition_regressions','number_format','save_store','isometric_projection')) {
  $env:APPDATA=Join-Path $env:TEMP ('kurye-company-'+$test+'-'+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
  $output=& $GodotPath --headless --path $projectRoot --script "res://tests/$test.gd" --quit-after 1000 2>&1
  $output | Write-Output
  if ($LASTEXITCODE -ne 0 -or ($output -match 'SCRIPT ERROR|ERROR:')) {throw "Failed: $test"}
 }
} finally {$env:APPDATA=$originalProfile}
