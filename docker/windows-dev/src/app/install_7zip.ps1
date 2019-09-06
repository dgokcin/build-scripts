#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$seven_zip_version_suffix = "${env:SEVEN_ZIP_VERSION}" -replace "\.", ""
$seven_zip_dist_name = "7z${seven_zip_version_suffix}-x64.msi"
$seven_zip_dist = "${PSScriptRoot}\${seven_zip_dist_name}"
if (-not (Test-Path -Path "${seven_zip_dist}")) {
  $seven_zip_url = "${env:SEVEN_ZIP_DOWNLOAD_URL}/${seven_zip_dist_name}"
  Write-Host "Downloading 7-Zip from ${seven_zip_url} into ${seven_zip_dist_name}"
  (New-Object System.Net.WebClient).DownloadFile("${seven_zip_url}", "${seven_zip_dist_name}")
}
Write-Host "Installing 7-Zip from ${seven_zip_dist} into ${env:SEVEN_ZIP_HOME}"
$p = Start-Process -FilePath msiexec `
  -ArgumentList ("/package", "${seven_zip_dist}", "/quiet", "/qn", "/norestart", "TargetDir=""${env:SEVEN_ZIP_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install 7-Zip"
}
Write-Host "7-Zip ${env:SEVEN_ZIP_VERSION} installed into ${env:SEVEN_ZIP_HOME}"
