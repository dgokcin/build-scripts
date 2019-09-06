#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$cmake_dist_base_name = "cmake-${env:CMAKE_VERSION}-win64-x64"
$cmake_dist_name = "${cmake_dist_base_name}.zip"
$cmake_dist = "${env:TMP}\${cmake_dist_name}"
$cmake_url = "${env:CMAKE_URL}/v${env:CMAKE_VERSION}/${cmake_dist_name}"
Write-Host "Downloading CMake from ${cmake_url} into ${cmake_dist}"
(New-Object System.Net.WebClient).DownloadFile("${cmake_url}", "${cmake_dist}")
$cmake_temp_dir = "${env:TMP}\${cmake_dist_base_name}"
Write-Host "Extracting CMake from ${cmake_dist} into ${cmake_temp_dir}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${cmake_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
Write-Host "Moving CMake from ${cmake_temp_dir} into ${env:CMAKE_HOME}"
[System.IO.Directory]::Move("${cmake_temp_dir}", "${env:CMAKE_HOME}")
Write-Host "CMake ${env:CMAKE_VERSION} installed into ${env:CMAKE_HOME}"
