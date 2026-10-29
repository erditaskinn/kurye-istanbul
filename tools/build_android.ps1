param(
    [string]$GodotPath = 'D:\Tools\Godot\4.6.3\Godot_v4.6.3-stable_win64_console.exe',
    [string]$SdkPath = "$env:LOCALAPPDATA\Android\Sdk",
    [string]$JavaPath = '',
    [string]$Preset = 'Android A9 Test'
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
if (-not $JavaPath) {
    $javaExecutable = Get-ChildItem (Join-Path $projectRoot '.tools\java') -Filter java.exe -Recurse | Select-Object -First 1
    if (-not $javaExecutable) { throw 'Portable JDK 17 missing under .tools/java' }
    $JavaPath = Split-Path -Parent (Split-Path -Parent $javaExecutable.FullName)
}
foreach ($required in @($GodotPath, "$JavaPath\bin\java.exe", "$SdkPath\platform-tools\adb.exe", "$projectRoot\.tools\godot-templates\android_debug.apk")) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Required build tool missing: $required" }
}
$buildTools = Get-ChildItem "$SdkPath\build-tools" -Directory | Sort-Object { [version]$_.Name } -Descending | Select-Object -First 1
if (-not $buildTools -or -not (Test-Path "$($buildTools.FullName)\apksigner.bat")) { throw 'Android build-tools/apksigner missing' }
$profileRoot = Join-Path $projectRoot '.tools\build-profile'
$godotSettings = Join-Path $profileRoot 'Godot'
$androidUser = Join-Path $projectRoot '.tools\android-user'
$logRoot = Join-Path $projectRoot 'build\android'
New-Item -ItemType Directory -Force -Path $godotSettings,$androidUser,$logRoot | Out-Null
$keyPath = Join-Path $androidUser 'debug.keystore'
$oldAppData = $env:APPDATA
$oldJava = $env:JAVA_HOME
$oldAndroid = $env:ANDROID_HOME
$oldAndroidUser = $env:ANDROID_USER_HOME
try {
    $env:APPDATA = $profileRoot
    $env:JAVA_HOME = $JavaPath
    $env:ANDROID_HOME = $SdkPath
    # Keep the existing adb authorization profile; only the APK signing key is isolated.
    if (-not (Test-Path -LiteralPath $keyPath)) {
        & "$JavaPath\bin\keytool.exe" -genkeypair -keystore $keyPath -storepass android -alias androiddebugkey -keypass android -dname 'CN=Android Debug,O=Android,C=US' -keyalg RSA -keysize 2048 -validity 10000
        if ($LASTEXITCODE -ne 0) { throw 'Debug keystore generation failed' }
    }
    $javaSetting = $JavaPath.Replace('\','/')
    $sdkSetting = $SdkPath.Replace('\','/')
    $keySetting = $keyPath.Replace('\','/')
    $settingsText = "[gd_resource type=`"EditorSettings`" format=3]`n`n[resource]`nexport/android/java_sdk_path = `"$javaSetting`"`nexport/android/android_sdk_path = `"$sdkSetting`"`nexport/android/debug_keystore = `"$keySetting`"`nexport/android/debug_keystore_user = `"androiddebugkey`"`nexport/android/debug_keystore_pass = `"android`"`n"
    [IO.File]::WriteAllText((Join-Path $godotSettings 'editor_settings-4.6.tres'), $settingsText, [Text.UTF8Encoding]::new($false))
    $importLog = Join-Path $logRoot 'a9-import.log'
    $exportLog = Join-Path $logRoot 'a9-export.log'
    & $GodotPath --headless --path $projectRoot --editor --import *> $importLog
    if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $importLog -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) { Get-Content $importLog -Tail 50; throw 'Godot import failed' }
    $apkName = if ($Preset -eq 'Android A9 Test') { 'istanbul-kurye-a9-test.apk' } else { 'istanbul-kurye-debug.apk' }
    $apkPath = Join-Path $projectRoot "build\$apkName"
    & $GodotPath --headless --path $projectRoot --export-debug $Preset $apkPath *> $exportLog
    if ($LASTEXITCODE -ne 0 -or (Select-String -LiteralPath $exportLog -Pattern 'SCRIPT ERROR|ERROR:' -Quiet)) { Get-Content $exportLog -Tail 60; throw 'Godot APK export failed' }
    & "$($buildTools.FullName)\apksigner.bat" verify --verbose --print-certs $apkPath | Set-Content (Join-Path $logRoot 'a9-signature.txt')
    if ($LASTEXITCODE -ne 0) { throw 'APK signature verification failed' }
    & "$($buildTools.FullName)\zipalign.exe" -c -P 16 -v 4 $apkPath | Set-Content (Join-Path $logRoot 'a9-alignment.txt')
    if ($LASTEXITCODE -ne 0) { throw 'APK zip alignment failed' }
    & "$($buildTools.FullName)\aapt.exe" dump badging $apkPath | Set-Content (Join-Path $logRoot 'a9-badging.txt')
    (Get-FileHash -LiteralPath $apkPath -Algorithm SHA256).Hash | Set-Content "$apkPath.sha256"
    Get-Item $apkPath | Select-Object FullName,Length
    Get-Content (Join-Path $logRoot 'a9-badging.txt') | Select-String 'package:|sdkVersion:|targetSdkVersion:|native-code:'
} finally {
    $env:APPDATA = $oldAppData
    $env:JAVA_HOME = $oldJava
    $env:ANDROID_HOME = $oldAndroid
    $env:ANDROID_USER_HOME = $oldAndroidUser
}
