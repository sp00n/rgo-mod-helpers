@echo off
REM Command: "rgo-deploy" (and optionally a version string)
REM This calls the "rgo-pack.bat" batch file and then moves the generated file directly to the PAK directory

SETLOCAL EnableDelayedExpansion

REM This variables defines that the script is run from the deploy file
SET IS_DEPLOY=1


REM *********************************************
REM *** Call the pack batch file
REM *********************************************
CALL rgo-pack.bat %1



REM *********************************************
REM *** Copy the file to the PAK folder
REM *********************************************
echo=
echo Moving the generated .pak file to the game's PAK directory...
move /Y "%PAK_FILE_WITH_PATH%" "%GAME_PAK_DIR%"


IF NOT errorlevel 1 (
    echo=
    echo=
    echo SUCCESS^^!
    echo Deployed to "%GAME_PAK_DIR%"
    echo=
) ELSE (
    echo=
    echo=
    echo ERROR^^!
    echo Something failed^^!
    echo=
    pause
)