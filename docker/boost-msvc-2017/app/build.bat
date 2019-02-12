@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
if errorlevel 1 goto exit

"%B2_BIN%" --toolset=%B2_TOOLSET% address-model=%BOOST_ADDRESS_MODEL% debug release link=%BOOST_LINKAGE% runtime-link=%BOOST_RUNTIME_LINKAGE% threading=multi install --prefix="%BOOST_INSTALL_DIR%" --without-python --without-mpi

:exit