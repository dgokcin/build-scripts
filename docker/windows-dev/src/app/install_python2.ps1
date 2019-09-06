#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$python_dist_name = "python-${env:PYTHON2_VERSION}.amd64.msi"
$python_dist_url = "${env:PYTHON2_URL}/${env:PYTHON2_VERSION}/${python_dist_name}"
$python_dist = "${env:TMP}\${python_dist_name}"
Write-Host "Downloading Python ${env:PYTHON2_VERSION} from ${python_dist_url} into ${python_dist}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${python_dist}")
Write-Host "Installing Python ${env:PYTHON2_VERSION} from ${python_dist} into ${env:PYTHON2_HOME}"
$p = Start-Process -FilePath "${python_dist}" `
  -ArgumentList ("/norestart", "/quiet", "/qn", "ALLUSERS=1", "TargetDir=""${env:PYTHON2_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Python ${env:PYTHON2_VERSION}"
}
Write-Host "Python ${env:PYTHON2_VERSION} installed into ${env:PYTHON2_HOME}"
