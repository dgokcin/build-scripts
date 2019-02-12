#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$dirs = @(
  "docker/win-builder",
  "docker/mingw",
  "docker/msvc-2017"
)

${dirs}.GetEnumerator() | ForEach-Object {
  ${dir} = $_
  pushd ${dir}
  Write-Host "Running tests in directory ${dir}"
  .\test.ps1
  popd
}
