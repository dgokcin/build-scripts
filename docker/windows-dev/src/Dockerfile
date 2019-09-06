#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM microsoft/windowsservercore:ltsc2016

COPY ["app/install_choco.ps1", "C:/app/"]
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_choco.ps1"

COPY ["app/install_7zip.ps1", "app/7z1801-x64.msi", "C:/app/"]
ENV SEVEN_ZIP_VERSION="18.01" \
    SEVEN_ZIP_DOWNLOAD_URL="http://www.7-zip.org/a" \
    SEVEN_ZIP_HOME="C:\Program Files\7-Zip"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_7zip.ps1"

COPY ["app/install_git.ps1", "C:/app/"]
ENV GIT_VERSION="2.23.0"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_git.ps1"

COPY ["app/install_cmake.ps1", "C:/app/"]
ENV CMAKE_VERSION="3.15.3" \
    CMAKE_URL="https://github.com/Kitware/CMake/releases/download" \
    CMAKE_HOME="C:\cmake"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_cmake.ps1"

COPY ["app/install_msys2.ps1", "app/msys2.bat", "C:/app/"]
ENV MSYS2_URL="http://repo.msys2.org/distrib" \
    MSYS2_TARGET="x86_64" \
    MSYS2_VERSION="20190524" \
    MSYS_HOME="C:\msys64"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_msys2.ps1"

COPY ["app/install_perl.ps1", "C:/app/"]
ENV ACTIVE_PERL_VERSION="5.26.3.2603" \
    ACTIVE_PERL_BUILD="a95bce075" \
    ACTIVE_PERL_URL="http://downloads.activestate.com/ActivePerl/releases" \
    ACTIVE_PERL_HOME="C:\Perl64"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_perl.ps1"

COPY ["app/install_python3.ps1", "C:/app/"]
ENV PYTHON3_URL="https://www.python.org/ftp/python" \
    PYTHON3_VERSION="3.7.4" \
    PYTHON3_HOME="C:\Python37"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_python3.ps1"

COPY ["app/install_python2.ps1", "C:/app/"]
ENV PYTHON2_URL="https://www.python.org/ftp/python" \
    PYTHON2_VERSION="2.7.16" \
    PYTHON2_HOME="C:\Python27"
RUN powershell -ExecutionPolicy Bypass -File "C:\app\install_python2.ps1"

RUN powershell "Remove-Item -Path "${env:TMP}\*" -Recurse -Force" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"

ENV DOWNLOAD_DIR="C:\download" \
    BUILD_DIR="C:\build" \
    TARGET_DIR="C:\target"

RUN mkdir "%DOWNLOAD_DIR%" && \
    mkdir "%BUILD_DIR%" && \
    mkdir "%TARGET_DIR%"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/windows-dev" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Base image for builders on Windows"
