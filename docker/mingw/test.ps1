#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Get version of MinGW x64 in container created from abrarov/mingw:latest image"
docker run --rm abrarov/mingw "C:\mingw64\bin\g++" --version

Write-Host "Get version of MinGW x86 in container created from abrarov/mingw:latest image"
docker run --rm abrarov/mingw "C:\mingw32\bin\g++" --version