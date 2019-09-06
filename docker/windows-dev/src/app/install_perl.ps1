#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$active_perl_dist_name = "ActivePerl-${env:ACTIVE_PERL_VERSION}-MSWin32-x64-${env:ACTIVE_PERL_BUILD}.exe"
$active_perl_url = "${env:ACTIVE_PERL_URL}/${env:ACTIVE_PERL_VERSION}/${active_perl_dist_name}"
$active_perl_dist = "${env:TMP}\${active_perl_dist_name}"
Write-Host "Downloading ActivePerl from ${active_perl_url} into ${active_perl_dist}"
(New-Object System.Net.WebClient).DownloadFile("${active_perl_url}", "${active_perl_dist}")
Write-Host "Installing ActivePerl from ${active_perl_dist} into ${env:ACTIVE_PERL_HOME}"
$p = Start-Process -FilePath "${active_perl_dist}" `
  -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn", "TargetDir=""${env:ACTIVE_PERL_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install ActivePerl"
}
Write-Host "ActivePerl ${env:ACTIVE_PERL_VERSION} installed into ${env:ACTIVE_PERL_HOME}"
