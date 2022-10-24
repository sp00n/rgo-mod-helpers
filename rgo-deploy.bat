@echo off
REM Command: "rgo-deploy" (and optionally a version string)
REM This calls the "rgo-pack.bat" batch file and then moves the generated file directly to the PAK directory

SETLOCAL EnableDelayedExpansion

REM This variables defines that the script is run from the deploy file
SET "IS_DEPLOY=1"


REM *********************************************
REM *** Call the pack batch file
REM *********************************************

REM Check if the PATH variable is set or the script is run from inside the directory
WHERE /q rgo-pack.bat

IF ERRORLEVEL 1 (
    echo=
    echo Couldn't find rgo-pack.bat^^!
    echo Please make sure it's in the same directory as this file or is available within
    echo one of the direcotries added to the PATH variable^^!
    pause
    GOTO :EOF
)

CALL rgo-pack.bat %1


IF ERRORLEVEL 1 (
    GOTO :EOF
)


REM *********************************************
REM *** Copy the file to the PAK folder
REM *********************************************
echo=
echo Moving the generated .pak file to the game's PAK directory...
move /Y "%PAK_FILE_WITH_PATH%" "%GAME_PAK_DIR%"


IF NOT ERRORLEVEL 1 (
    echo=
    echo=
    echo SUCCESS^^!
    echo Deployed to "%GAME_PAK_DIR%"
    echo=
) ELSE (
    echo=
    echo=
    echo -------------------------------------------------------------------------------------
    echo ERROR^^!
    echo Something failed^^!
    echo -------------------------------------------------------------------------------------
    echo=
    echo The .pak file was created, but it couldn't be moved to the game directory.
    echo Maybe the directory is write protected or you do not have sufficient permissions to
    echo access it.
    echo The latter could be the case if you're trying to access a folder inside the
    echo "C:\Program Files" directory, there only programs/scripts with administrator rights
    echo can create files.
    echo This could be the case if you're running the Steam version of the game.
    echo=
    echo You could try to run the script in administrator mode ^(not recommended^), or you
    echo could manually copy the generated file to the game's PAKS folder.
    echo=
    echo The generated file:
    echo "%PAK_FILE_WITH_PATH%"
    echo=
    echo The game's PAKS directory path:
    echo "%GAME_PAK_DIR%"
    echo=

    echo=
    pause
)