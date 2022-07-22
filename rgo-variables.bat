@echo off
REM This file just containes the path variables that the other batch file use
REM Change them according to your installation

REM The path where the lua utils are stored
REM Do not use quotes here
REM Do not add a trailing slash
SET UTILS_DIR=D:\Tools\rgo-lua-utils


REM The path to your Rebel Galaxy Outlaw game installation
REM Do not use quotes here
REM Do not add a trailing slash
SET GAME_DIR=D:\Games\Rebel Galaxy Outlaw





REM --------------------------------------------------------------------------
REM Do not change the variables below
REM --------------------------------------------------------------------------

SET GAME_PAK_DIR=%GAME_DIR%\PAKS\
SET BAT_DIR=%~dp0
SET CURRENT_PATH=%cd%


REM Get the name of the folder where this script was started from (not the path)
FOR %%I in (.) DO SET FOLDER_NAME=%%~nxI


IF NOT DEFINED CALLER (
    echo This batch file is not intended to be executed, it merely holds the
    echo configuration data for the other rgo batch files.
    echo=
    echo  - Change the "UTILS_DIR" variable to the path where your
    echo    RGO LUA Utilities are located
    echo  - Change the "GAME_DIR" variable to the path where your
    echo    Rebel Galaxy Outlaw installation is located
    pause
)