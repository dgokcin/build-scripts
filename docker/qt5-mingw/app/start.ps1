#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$qt_version_short = "${env:QT_VERSION}" -replace '(\d+)\.(\d+)\.(\d)', '$1.$2'
$qt_dist_base_name = "qt-everywhere-src-"
$qt_archive_file = "${env:DOWNLOAD_DIR}\${qt_dist_base_name}${env:QT_VERSION}.zip"
$qt_download_url = "${env:QT_URL}/${qt_version_short}/${env:QT_VERSION}/single/${qt_dist_base_name}${env:QT_VERSION}.zip"

$openssl_base_dir = "${env:DEPEND_DIR}"
if (Test-Path env:OPENSSL_DIR) {
  $openssl_base_dir = "${env:OPENSSL_DIR}"
}

# Build Qt
$address_models = @("64", "32")
$qt_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:QT_ADDRESS_MODEL) {
  $address_models = @("${env:QT_ADDRESS_MODEL}")
}
if (Test-Path env:QT_LINKAGE) {
  $qt_linkages = @("${env:QT_LINKAGE}")
}

$mingw_version_suffix = "${env:MINGW_VERSION}" -replace "\.", ''
$compiler_target_dir_suffix = "mingw${mingw_version_suffix}"
$qt_downloaded = $false

foreach ($address_model in ${address_models}) {
  $env:QT_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:QT_ADDRESS_MODEL}) {
    "32" {
      $env:MINGW_HOME = "${env:MINGW32_HOME}"
      $address_model_target_dir_suffix = "x86"
    }
    "64" {
      $env:MINGW_HOME = "${env:MINGW64_HOME}"
      $address_model_target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: ${env:QT_ADDRESS_MODEL}"
    }
  }

  foreach ($qt_linkage in ${qt_linkages}) {
    $env:QT_LINKAGE = ${qt_linkage}
    $env:QT_BUILD_DIR = "${env:BUILD_DIR}\qt-${env:QT_VERSION}\${address_model}\${env:QT_LINKAGE}"
    $env:QT_HOME = "${env:QT_BUILD_DIR}\${qt_dist_base_name}${env:QT_VERSION}"
    Write-Host "Assuming root folder for sources is: ${env:QT_HOME}"

    $env:QT_CONFIGURE_OPTIONS_LINKAGE = ""
    switch (${env:QT_LINKAGE}) {
      "static" {
        $env:QT_CONFIGURE_OPTIONS_LINKAGE = "-static"
      }
      "shared" {
        $env:QT_CONFIGURE_OPTIONS_LINKAGE = ""
      }
      default {
        throw "Unsupported linkage: $env:QT_LINKAGE"
      }
    }

    if (Test-Path -Path "${env:QT_HOME}") {
      Write-Host "Found existing folder ${env:QT_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
    } else {
      if (-not ${qt_downloaded}) {
        if (Test-Path -Path "${qt_archive_file}") {
          Write-Host "Found existing file ${qt_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
        } else {
          # Download Qt
          Write-Host "Downloading Qt (source code archive) from: ${qt_download_url} into: ${qt_archive_file}"
          (New-Object System.Net.WebClient).DownloadFile("${qt_download_url}", "${qt_archive_file}")
        }
        $qt_downloaded = $true
      }

      if (-not (Test-Path -Path "${env:QT_BUILD_DIR}")) {
        New-Item -path "${env:QT_BUILD_DIR}" -type directory | out-null
      }

      # Unpack Qt
      Write-Host "Extracting source code archive from ${qt_archive_file} to ${env:QT_BUILD_DIR}"
      & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${qt_archive_file}" -o"${env:QT_BUILD_DIR}" -aoa -y
      if (${LastExitCode} -ne 0) {
        throw "Failed to extract Qt from ${qt_archive_file} to ${env:QT_BUILD_DIR}"
      }
      Write-Host "Extracted source code archive"
    }

    $env:QT_INSTALL_DIR = "${env:TARGET_DIR}\qt-${env:QT_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:QT_LINKAGE}"

    # Prepare patch for Qt
    $env:QT_PATCH_FILE = ""
    if (Test-Path env:QT_PATCH) {
      $env:QT_PATCH_FILE = "${env:QT_PATCH}"
    } else {
      $env:QT_PATCH_FILE = "${env:SCRIPT_DIR}\patches\qt-${env:QT_VERSION}-${env:QT_LINKAGE}.patch"
    }
    if ("${env:QT_PATCH_FILE}" -ne "" -and -not (Test-Path -Path "${env:QT_PATCH_FILE}")) {
      Write-Warning "Patch for chosen version of Qt (${env:QT_VERSION}) and linkage (${env:QT_LINKAGE}) was not found at ${env:QT_PATCH_FILE}"
      $env:QT_PATCH_FILE = ""
    }
    $env:QT_PATCH_MSYS_FILE = "${env:QT_PATCH_FILE}" -replace "\\", "/"
    $env:QT_PATCH_MSYS_FILE = "${env:QT_PATCH_MSYS_FILE}" -replace "^(C):", "/c"

    $env:OPENSSL_DIR = "${openssl_base_dir}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:QT_LINKAGE}"
    if (-not (Test-Path -Path "${env:OPENSSL_DIR}")) {
      Write-Error "OpenSSL not found at ${env:OPENSSL_DIR}"
    }

    Set-Location -Path "${env:QT_HOME}"

    Write-Host "Building Qt with theses parameters:"
    Write-Host "MINGW_HOME                   : ${env:MINGW_HOME}"
    Write-Host "OPENSSL_DIR                  : ${env:OPENSSL_DIR}"
    Write-Host "QT_HOME                      : ${env:QT_HOME}"
    Write-Host "QT_INSTALL_DIR               : ${env:QT_INSTALL_DIR}"
    Write-Host "QT_ADDRESS_MODEL             : ${env:QT_ADDRESS_MODEL}"
    Write-Host "QT_LINKAGE                   : ${env:QT_LINKAGE}"
    Write-Host "QT_CONFIGURE_OPTIONS_LINKAGE : ${env:QT_CONFIGURE_OPTIONS_LINKAGE}"
    Write-Host "QT_PATCH_FILE                : ${env:QT_PATCH_FILE}"
    Write-Host "QT_PATCH_MSYS_FILE           : ${env:QT_PATCH_MSYS_FILE}"

    & "${env:SCRIPT_DIR}\build.bat"
    if (${LastExitCode} -ne 0) {
      throw "Failed to build Qt with QT_ADDRESS_MODEL = ${env:QT_ADDRESS_MODEL}, QT_LINKAGE = ${env:QT_LINKAGE}"
    }
  }
}

Write-Host "Build completed successfully"