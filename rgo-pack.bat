@echo off
REM Command: "rgo-pack version_number"
REM Internally executed command: lua "path\to\lua-utils\pack.lua" "path\to\folder\DAT" "path\to\folder\folder_name.v[version].pak"
REM This file copies all the files from the LUA folder to the DAT folder,
REM Then it converts all the .lua files to their .DAT, .WDAT, .LAYOUT, etc counterparts
REM Then it packs all the files in the DAT folder into a .PAK file, which has the same name as the folder that this batch file was called from
REM You can optionally add a version string to the .PAK file


REM Check if the PATH variable is set or the script is run from inside the directory
WHERE /q rgo-variables.bat

IF ERRORLEVEL 1 (
    echo=
    echo Couldn't find rgo-variables.bat^^!
    echo Please make sure it's in the same directory as this file or is available within
    echo one of the directories added to the PATH variable^^!
    pause
    GOTO :EOF
)


REM Check for the existance of the lua.exe
WHERE /q lua.exe

IF ERRORLEVEL 1 (
    echo=
    echo Couldn't find lua.exe^^!
    echo Please make sure the lua.exe is available within one of the directories added
    echo to the PATH variable^^!
    pause
    GOTO :EOF
)


SET "CALLER=pack"
CALL rgo-variables.bat


SET "VERSION=%1"
SET "MOD_FOLDER=%CURRENT_PATH%"
SET "MOD_FOLDER_LUA=%CURRENT_PATH%\LUA"
SET "MOD_FOLDER_DAT=%CURRENT_PATH%\DAT"


IF [%VERSION%] == [] (
    SET "PAK_FILE=%FOLDER_NAME%.pak"
) ELSE (
    SET "PAK_FILE=%FOLDER_NAME%.v%VERSION%.pak"
)

SET "PAK_FILE_WITH_PATH=%MOD_FOLDER%%FOLDER%\%PAK_FILE%"


REM Note: this cannot appear before the variables are set, otherwise rgo-deploy.bat will fail due to missing variables
SETLOCAL EnableDelayedExpansion


REM echo BAT_DIR:        %BAT_DIR%
REM echo UTILS_DIR:      %UTILS_DIR%
REM echo CURRENT_PATH:       %CURRENT_PATH%
REM echo CURRENT_FOLDER:     %CURRENT_FOLDER%
REM echo MOD_FOLDER:         %MOD_FOLDER%
REM echo MOD_FOLDER_LUA:     %MOD_FOLDER_LUA%
REM echo MOD_FOLDER_DAT:     %MOD_FOLDER_DAT%
REM echo PAK_FILE:           %PAK_FILE%
REM echo PAK_FILE_WITH_PATH: %PAK_FILE_WITH_PATH%
REM echo COMMAND:
REM echo lua pack.lua "%FINAL_FOLDER%" "%FINAL_FILE%"



REM echo %%~dp0 is "%~dp0"
REM echo %%0 is "%0"
REM echo %%~dpnx0 is "%~dpnx0"
REM echo %%~f1 is "%~f1"
REM echo %%~dp0%%~1 is "%~dp0%~1"


echo=
echo ================================================================================
echo Generating a new mod pak file: %PAK_FILE%
echo ================================================================================
echo=


IF NOT EXIST "%MOD_FOLDER_LUA%" (
    echo=
    echo Couldn't find the LUA directory with the files for the package, aborting^^!
    pause
    cmd /c exit 1
    GOTO :EOF
)



REM *********************************************
REM *** Remove the existing DAT directory
REM *********************************************
echo=
echo Removing existing DAT directory...
rd /S /Q "%MOD_FOLDER_DAT%"

IF ERRORLEVEL 1 (
    pause
    cmd /c exit 1
    GOTO :EOF
)



REM *********************************************
REM *** Copy all the files first
REM *********************************************
echo=
echo Copying files...
xcopy /E /I /R /Y "%MOD_FOLDER_LUA%" "%MOD_FOLDER_DAT%"

IF ERRORLEVEL 1 (
    pause
    cmd /c exit 1
    GOTO :EOF
)



REM *********************************************
REM *** Convert the lua files
REM *********************************************
echo=
echo Converting all .lua files...
FOR /f "tokens=* delims=" %%a in ('dir "%MOD_FOLDER_DAT%\*.lua" /s /b') do (
    SET "FILE=%%a"
    SET "DAT_FILE=!FILE:.lua=!"
    SET "BASEFILE=%%~na"

    rem echo=
    rem echo From: !FILE!
    rem echo To:   !DAT_FILE!
    rem echo Base: !BASEFILE!
    rem echo first 3: !BASEFILE:~0,3!
    
    echo Generating "!DAT_FILE!"

    rem Check if we need to convert to a layout file
    IF /i "16_" equ "!BASEFILE:~0,3!" (
        lua.exe "%UTILS_DIR%\lua2layout.lua" "!FILE!" "!DAT_FILE!"
    ) ELSE (
        lua.exe "%UTILS_DIR%\lua2dat.lua" "!FILE!" "!DAT_FILE!"
    )


    IF ERRORLEVEL 1 (
        pause
        cmd /c exit 1
        GOTO :EOF
    )
)



REM *********************************************
REM *** Remove the lua files from the copied dir
REM *********************************************
echo=
echo Cleaning up...
del /S /Q "%MOD_FOLDER_DAT%\*.lua"

IF ERRORLEVEL 1 (
    pause
    cmd /c exit 1
    GOTO :EOF
)



REM *********************************************
REM *** Pack the files
REM *********************************************
echo=
echo Generating the .pak file...
lua.exe "%UTILS_DIR%\pack.lua" "%MOD_FOLDER_DAT%" "%PAK_FILE_WITH_PATH%"

IF ERRORLEVEL 1 (
    pause
    cmd /c exit 1
    GOTO :EOF
)



REM *********************************************
REM *** Change the date of the pak file
REM *********************************************
echo=
echo Changing the date of the .pak file...
"%BAT_DIR%\nircmd.exe" setfiletime "%PAK_FILE_WITH_PATH%" "01-01-2099 10:00:00" "01-01-2099 10:00:00"


IF NOT ERRORLEVEL 1 (
    echo=
    echo=
    
    IF DEFINED IS_DEPLOY (
        REM empty line
    ) ELSE (
        echo SUCCESS^^!
    )

    echo Created "%PAK_FILE_WITH_PATH%"
    echo=
)