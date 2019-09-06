#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download and install Python 3.x
$python_dist_name = "python-${env:PYTHON3_VERSION}-amd64.exe"
$python_dist_url = "${env:PYTHON3_URL}/${env:PYTHON3_VERSION}/${python_dist_name}"
$python_dist = "${env:TMP}\${python_dist_name}"
Write-Host "Downloading Python ${env:PYTHON3_VERSION} from ${python_dist_url} into ${python_dist}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${python_dist}")
Write-Host "Installing Python ${env:PYTHON3_VERSION} from ${python_dist} into ${env:PYTHON3_HOME}"
$p = Start-Process -FilePath "${python_dist}" `
  -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn", "InstallAllUsers=1", "TargetDir=""${env:PYTHON3_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Python ${env:PYTHON3_VERSION}"
}
Write-Host "Python ${env:PYTHON3_VERSION} installed into ${env:PYTHON3_HOME}"
