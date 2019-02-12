#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

#TODO: find way to deal with tags and versions
$image_version = "2.0.0"
$image_revision = "$(git rev-parse --verify HEAD)"

Write-Host "Building abrarov/icu-mingw:${image_version} image with ${image_revision} revision"
docker build -t abrarov/icu-mingw:${image_version} --build-arg image_version=${image_version} --build-arg image_revision=${image_revision} .

Write-Host "Tagging abrarov/icu-mingw:${image_version} image as latest"
docker tag abrarov/icu-mingw:${image_version} abrarov/icu-mingw:latest
