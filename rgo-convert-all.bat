@echo off
REM This file unpacks all the DATAX.PAK files in the path/directory you specify
REM If no path is specified, the "DATA" directory inside the PAKS folder will be used
REM After unpacking, it will also convert all the .DAT, .WDAT, .IMAGESET, and .LAYOUT file to LUA files
REM Paths can either be absolute (e.g. "D:\Games\RGO\MODS\DATA\EXTRACTED") or relative (just "MODS\DATA\EXTRACTED")
REM In the case of relative paths, they will be relative to the Game installation directory, not the path you're executing the batch file from!


SETLOCAL EnableExtensions EnableDelayedExpansion


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


SET "CALLER=convert-all"
CALL rgo-variables.bat


REM Check if a parameter was passed or not
REM The parameter will be the destination directory for the extracted files
REM If none was set, we're using DATA directory inside the original location
IF "%~1"=="" (
    SET "LOCATION=PAKS\DATA"
) ELSE (
    SET "LOCATION=%~1"
)

REM Remove any trailing backslash
IF %LOCATION:~-1%==\ (
    SET "LOCATION=%LOCATION:~0,-1%"
)


REM Check if the LOCATION contains ":\"
REM If it does, treat it as an absolute path
REM Otherwise it's relative to the game dir
IF NOT x"%LOCATION::\=%"==x"%LOCATION%" (
    SET "EXTRACT_DIR=%LOCATION%"
) ELSE (
    SET "EXTRACT_DIR=%GAME_DIR%\%LOCATION%"
)


REM Create the directory if necessary
IF EXIST "%EXTRACT_DIR%\" (
    echo Directory "%EXTRACT_DIR%" already exists...
) ELSE (
    echo Creating directory "%EXTRACT_DIR%"...
    mkdir "%EXTRACT_DIR%"
)


IF ERRORLEVEL 1 (
    echo=
    echo -------------------------------------------------------------------------------------
    echo Couldn't create "%EXTRACT_DIR%", aborting^^!
    echo -------------------------------------------------------------------------------------
    echo=
    echo Maybe the directory is write protected or you do not have sufficient permissions to
    echo access it.
    echo The latter could be the case if you're trying to access a folder inside the
    echo "C:\Program Files" directory, there only programs/scripts with administrator rights
    echo can create folders.
    echo This is very likely if you're running the Steam version of the game.
    echo=
    echo You could try to run the script in administrator mode ^(not recommended^), or you
    echo could could simply provide a destination folder for the extracted files like so:
    echo=
    echo rgo-convert-all.bat "D:\Modding\RGO\DATA"
    echo=
    echo The extracted files will then be copied into this directory.
    echo=
    pause
    GOTO :EOF
)

IF NOT EXIST "%EXTRACT_DIR%\" (
    echo=
    echo Couldn't create "%EXTRACT_DIR%", aborting^^!
    pause
    GOTO :EOF
)



REM Extract all files
echo Extracting all .PAK files...
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA0.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA1.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA2.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA3.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA4.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA5.PAK" "%EXTRACT_DIR%"
lua.exe "%UTILS_DIR%\unpack.lua" "%GAME_PAK_DIR%DATA6.PAK" "%EXTRACT_DIR%"


REM Convert all the files to .lua
echo Converting to .lua files...


REM Change to the data dir
pushd "%EXTRACT_DIR%"


REM Convert the original files
FOR /R %%F IN (*.WDAT, *.IMAGESET, *.DAT) DO (
    SET "LUA_FILE=%%F.lua"
    
    rem echo File:     %%F
    rem echo LUA_FILE: "!LUA_FILE!"
    
    lua.exe "%UTILS_DIR%\dat2lua.lua" "%%F" "!LUA_FILE!"

    IF NOT ERRORLEVEL 1 (
        rem echo Created "!LUA_FILE!"
    ) ELSE (
        echo ERROR: Could not create "!LUA_FILE!"
    )
)


REM Convert the layout files
FOR /R %%F IN (*.LAYOUT) DO (
    SET "LUA_FILE=%%F.lua"
    
    rem echo File:     %%F
    rem echo LUA_FILE: "!LUA_FILE!"
    
    lua.exe "%UTILS_DIR%\layout2lua.lua" "%%F" "!LUA_FILE!"

    IF NOT ERRORLEVEL 1 (
        rem echo Created "!LUA_FILE!"
    ) ELSE (
        echo ERROR: Could not create "!LUA_FILE!"
    )
)


REM Return to the previous directory
popd