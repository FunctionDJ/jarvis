@echo off
title Virtual SD Card Maker for Dolphin

:size
cls
echo  What size of the virtual SD card would you like to create?
echo.
echo        1 - 64    MB
echo        2 - 128   MB
echo        3 - 256   MB
echo        4 - 512   MB
echo.
echo        - - - - Recommended (for large Homebrew apps like Project M) - - - -
echo.
echo        5 - 1024  MB (1GB)
echo        6 - 2048  MB (2GB)
echo.
echo        - - - - "SDHC" (not recommended for most Homebrew apps) - - - -
echo.
echo        7 - 4096  MB (4GB)
echo        8 - 8192  MB (8GB)
echo        9 - 16384 MB (16GB)
echo        0 - 32768 MB (32GB)
echo.
echo        C - Custom size
echo        X - Exit
echo.
CHOICE /C:1234567890cx /N /M "Your input (Up next: Location):"
if "%ERRORLEVEL%"=="1" set size=64M
if "%ERRORLEVEL%"=="2" set size=128M
if "%ERRORLEVEL%"=="3" set size=256M
if "%ERRORLEVEL%"=="4" set size=512M
if "%ERRORLEVEL%"=="5" set size=1024M
if "%ERRORLEVEL%"=="6" set size=2048M
if "%ERRORLEVEL%"=="7" set size=4096M
if "%ERRORLEVEL%"=="8" set size=8192M
if "%ERRORLEVEL%"=="9" set size=16384M
if "%ERRORLEVEL%"=="10" set size=32768M
if "%ERRORLEVEL%"=="11" goto :custom
if "%ERRORLEVEL%"=="12" goto :end
goto dolphinwii

:custom
cls
echo  Type custom size then add "M" (MB) (case sensitive) then enter.
echo  Instead "M" with "B" (B) or "K" (KB) is possible for fine-grained custom size.
echo.
echo        - - - - Example - - - -
echo.
echo        Custom size:902M
echo        Custom size:901374K
echo.
echo        - - - - - - - - - - - -
echo.
set /p size=Custom size:
goto dolphinwii

:dolphinwii
if exist "%~dp0..\..\Wii" (goto native) else (if exist "%userprofile%\Documents\Dolphin Emulator\Wii" (set profile=%userprofile%\Documents\Dolphin Emulator\Wii
goto sdlocation) else (cls
color 4c
echo  This batch file couldn't able to locate the Dolphin profile.
echo  Try place \Virtual SD Card Maker\ folder into your current Dolphin profile!
echo.
echo        - - - - Example - - - -
echo.
echo        \Dolphin Emulator\Themes\
echo      ^> \Dolphin Emulator\Virtual SD Card Maker\
echo        \Dolphin Emulator\Wii\
echo.
echo        - - - - - - - - - - - -
echo.
echo  At the moment the virtual SD card will only be created on Desktop.
echo.
set sdlocation="%userprofile%\Desktop\sd.raw"
set profile=%userprofile%\Desktop
goto start))

:native
cd %~dp0..\..
set profile=%cd%\Wii
goto sdlocation

:sdlocation
cd "%profile%"
if exist "sd.raw" (cls
color 2a
echo  Virtual SD card exists in your Dolphin profile:
echo        %profile%\sd.raw
echo.
echo  Would you like to erase and replace it with different size?
echo.
echo        1 - Overwrite virtual SD card in Dolphin profile
echo        2 - Back up virtual SD card then replace) else (cls
color 3b
echo        %profile%\sd.raw
echo  Doesn't seem to exist . . .
echo.
echo  Would you like to create new in Dolphin profile?
echo.
echo        1 - Create new virtual SD card in Dolphin profile
echo        2 - Same as option 1)
echo        3 - Create new virtual SD card on Desktop
echo.
echo        B - Back to last step
echo        X - Exit
echo.
:loop
CHOICE /C:123bx /N /M "Your input (Up next: Review):"
if "%ERRORLEVEL%"=="1" set sdlocation="%profile%\sd.raw"
if "%ERRORLEVEL%"=="2" goto :backup
if "%ERRORLEVEL%"=="3" set profile=%userprofile%\Desktop && set sdlocation="%userprofile%\Desktop\sd.raw"
if "%ERRORLEVEL%"=="4" goto :size
if "%ERRORLEVEL%"=="5" goto :end
cls
goto start

:backup
if exist "%profile%\sd.raw" (if exist "%profile%\sd.raw.old" (echo  You have an older backup ^("sd.raw.old"^)! Not going to overwrite it.
goto loop) else (ren sd.raw sd.raw.old
echo.
echo  Pre-existing virtual SD card now has been backed up as "sd.raw.old".
timeout /t 4 >nul
echo.)) else (echo.)
set sdlocation="%profile%\sd.raw"
cls
goto start

:start
echo  Do you confirm the following?
echo.     
echo        ^> Virtual SD card size will be %size%
echo        ^> Virtual SD card will be
echo          %sdlocation%
echo.
echo        Y - Yes
echo        B - Back to last step
echo        S - Back to size options
echo        X - Exit
echo.
CHOICE /C:ybsx /N /M "Your input (Up next: Open or Exit):"
if "%ERRORLEVEL%"=="1" goto :confirm
if "%ERRORLEVEL%"=="2" goto :dolphinwii
if "%ERRORLEVEL%"=="3" goto :size
if "%ERRORLEVEL%"=="4" goto :end

:confirm
cls
color 5d
echo.
echo  Now creating . . .
"%~dp0mksdcard.exe" %size% %sdlocation%
cls
color 3b
echo.
echo  Now creating . . . Created.
echo  It can be mounted using ImDisk Virtual Disk Driver (link in readme.txt).
echo.
echo        D - Open directory to newly created virtual SD card
echo        X - Exit
echo.
CHOICE /C:dx /N /M "Your input:"
if "%ERRORLEVEL%"=="1" start "" explorer.exe "%profile%" && echo Exiting in 10 seconds . . . && timeout /t 10 >nul
if "%ERRORLEVEL%"=="2" goto end

:end
exit