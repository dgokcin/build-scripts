#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$msys_tar_name = "msys2-base-${env:MSYS2_TARGET}-${env:MSYS2_VERSION}.tar"
$msys_dist_name = "${msys_tar_name}.xz"
$msys_url = "${env:MSYS2_URL}/${env:MSYS2_TARGET}/${msys_dist_name}"
$msys_dist = "${env:TMP}\${msys_dist_name}"
Write-Host "Downloading MSYS2 from ${msys_url} into ${msys_dist}"
(New-Object System.Net.WebClient).DownloadFile("${msys_url}", "${msys_dist}")
Write-Host "Extracting MSYS2 from ${msys_dist} into ${env:MSYS_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${msys_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${env:TMP}\${msys_tar_name}" -o"C:" -aoa -y -bd | out-null
& "${PSScriptRoot}\msys2.bat"
Write-Host "MSYS2 ${env:MSYS2_VERSION} installed into ${env:MSYS_HOME}"
