@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set PATH=%MSYS_HOME%\usr\bin;%MINGW_HOME%\bin;%PATH%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%OPENSSL_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

if "%OPENSSL_LINKAGE%" == "shared" (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% shared
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% enable-static-engine no-shared
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

make depend
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%