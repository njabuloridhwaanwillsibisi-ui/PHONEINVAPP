$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
# Requires JDK 17 and Android SDK Platform 35. Android Studio supplies these.
if (-not $env:JAVA_HOME) {
    $studioJdk = Join-Path $env:ProgramFiles 'Android\Android Studio\jbr'
    if (Test-Path $studioJdk) { $env:JAVA_HOME = $studioJdk }
}
if ($env:JAVA_HOME) { $env:PATH = "$env:JAVA_HOME\bin;$env:PATH" }
if (-not $env:ANDROID_HOME) {
    $sdkPath = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
    if (Test-Path $sdkPath) { $env:ANDROID_HOME = $sdkPath }
}
if (-not (Get-Command java -ErrorAction SilentlyContinue)) { throw 'Install Android Studio with its JDK, or set JAVA_HOME to JDK 17.' }
if (-not $env:ANDROID_HOME) { throw 'Set ANDROID_HOME to your Android SDK folder, or open this project in Android Studio first.' }
$tools = Join-Path $PSScriptRoot '.build-tools'
$gradle = Join-Path $tools 'gradle-8.9\bin\gradle.bat'
if (-not (Test-Path $gradle)) {
    New-Item -ItemType Directory -Force $tools | Out-Null
    $archive = Join-Path $tools 'gradle-8.9-bin.zip'
    $url = 'https://services.gradle.org/distributions/gradle-8.9-bin.zip'
    Write-Host 'Downloading Gradle 8.9 from its official distribution service...'
    Invoke-WebRequest $url -OutFile $archive
    $checksum = (Invoke-RestMethod "$url.sha256").Trim().Split(' ')[0]
    if ((Get-FileHash $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $checksum.ToLowerInvariant()) { Remove-Item $archive; throw 'Gradle download checksum mismatch.' }
    Expand-Archive $archive -DestinationPath $tools -Force
}
& $gradle --no-daemon :app:assembleDebug
if ($LASTEXITCODE -ne 0) { throw 'Build failed. Check the messages above and SDK installation.' }
Copy-Item 'app\build\outputs\apk\debug\app-debug.apk' 'PocketStock.apk' -Force
Write-Host "APK ready: $PSScriptRoot\PocketStock.apk"
