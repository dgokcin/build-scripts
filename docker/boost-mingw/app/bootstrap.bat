@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
rem

set PATH=%PATH%;%MINGW_HOME%\bin
if errorlevel 1 goto exit

call "%BOOST_BOOTSTRAP%" gcc

:exit