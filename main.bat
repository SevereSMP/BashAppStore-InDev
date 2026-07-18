@echo off
::CONFIG
set "store_url=cmds.severesmp.org/store" ::This is the URL of the store this wont work because the store is not online yet
::END CONFIG
::DEV VARS
::Set to 1 for development mode, 0 for production mode
set "dev_mode=1" 

echo STARTING CMD STORE V%ver%
echo Server: %store_url%
if "%dev_mode%"=="1" (
    echo [DEV MODE] Development mode is enabled.
)
set "ver=1.0-B"
::END DEV VARS
::curl

:home
cls
title CMD_Store_V%ver%
echo ==========================================
echo       Welcome to the CMD Store
echo 1. Goto Store
echo 2. Clear old files (Do this if you just installed an application)
echo 3. Exit
echo ==========================================
if "%dev_mode%"=="1" (
    echo ==========================================
    echo [DEV MODE] Server: %store_url%
    echo [DEV MODE] API: %store_url%/api
    echo [DEV MODE] Temporary Install Directory: %Temp%\CMDStoreInstall
    echo [DEV MODE] Type 61. to test the store API (this will fetch the list of available applications PG1)
    echo [DEV MODE] Type 62. to install app without clearing screen
    echo ==========================================
)
set /p choice=Please enter your choice (1-3):

:: Process the user's choice
if "%choice%"=="1" goto store
if "%choice%"=="2" goto del-old
if "%choice%"=="3" exit
::DEV MODE OPTIONS
if "%dev_mode%"=="1" (
    if "%choice%"=="62" (
        cls
        echo ==========================================
        set /p "app_choice=[DEV MODE] Enter the application number to install (or type 'back' to return to the main menu): "
        if "%app_choice%"=="back" goto home
        echo [DEV MODE] Installing application with ID: %app_choice%...
        set "install_dir=%Temp%\CMDStoreInstall"
        if not exist "%install_dir%" mkdir "%install_dir%"
        set "installer_path=%install_dir%\installer.exe"
        set "installer_url=%store_url%/api/get-url.php?id=%app_choice%"

        wget %installer_url% -O "%installer_path%"
        if %errorlevel% neq 0 (
            
            echo ==========================================
            echo Failed to download the installer. Please check the application ID or network connection and try again.
            echo Fetch API URL: %installer_url%
            echo Server: %store_url%
            echo Error Code: %errorlevel%
            echo ==========================================
            pause
            
            goto home
        )

        if exist "%installer_path%" (
            cd "%Temp%\CMDStoreInstall"
            
            echo Running the installer...
            start "" "%installer_path%"
            echo Installation started. Please follow the installer prompts.

        ) else (
            
            echo Installer file not found after download.
            echo Please check your temporary folder and try again.
            pause
            
        )
        goto home
    )
    if "%choice%"=="61" (
        cls
        echo ==========================================
        echo [DEV MODE] Fetching the list of available applications...
        mkdir "%Temp%\CMDStoreInstall"
        cd %temp%\CMDStoreInstall
        wget %store_url%/api/get-list.php?page=%page% -O list.txt
        echo CLEAR HERE BUT FOR DEV ITS NOT CLEAR
        type list.txt
        echo ==========================================
        pause
        goto home
    )
)

set "emsg=Invalid choice. Please enter a valid option (1-3)."
goto show_error

:store
cls
echo ==========================================
set /p page=Enter the page number to view: 
echo Getting the list of available applications...
mkdir "%Temp%\CMDStoreInstall"
cd %temp%\CMDStoreInstall
wget %store_url%/api/get-list.php?page=%page% -O list.txt
cls
echo ==========================================
echo List of available applications (Page %page%):
type list.txt
echo ==========================================
set /p app_choice=Enter the application number to install (or type 'back' to return to the main menu):
if "%app_choice%"=="back" goto home

:: Installer (sooo why are you digging into this code if you are not a developer or programmer just a thought you dont need to answer nope i- i- i- its fine)
cls
echo Installing application with ID: %app_choice%...
set "install_dir=%Temp%\CMDStoreInstall"
if not exist "%install_dir%" mkdir "%install_dir%"
set "installer_path=%install_dir%\installer.exe"
set "installer_url=%store_url%/api/get-url.php?id=%app_choice%"

wget %installer_url% -O "%installer_path%"
if %errorlevel% neq 0 (
    cls
    echo ==========================================
    echo Failed to download the installer. Please check the application ID or network connection and try again.
    echo Fetch API URL: %installer_url%
    echo Server: %store_url%
    echo Error Code: %errorlevel%
    echo ==========================================
    pause
    cls
    goto home
)

if exist "%installer_path%" (
    cd "%Temp%\CMDStoreInstall"
    cls
    echo Running the installer...
    start "" "%installer_path%"
    echo Installation started. Please follow the installer prompts.
    
    pause
) else (
    cls
    echo Installer file not found after download.
    echo Please check your temporary folder and try again.
    pause
    cls
)
goto home

:del-old
cd %temp%
cls
echo ==========================================
echo Deleting old files in the temporary directory...
del /q "%Temp%\CMDStoreInstall\*.*"
rmdir /s /q "%Temp%\CMDStoreInstall"
echo Old files deleted successfully.
echo ==========================================
pause
cls
goto home

::Error handling
:show_error
cls
title CMD_Store_V%ver% - Error! - %emsg%
color 4
echo ==========================================
echo An error occurred during the operation.
echo Please check the details below:
echo Error Code: %errorlevel%
echo Error Message: %emsg%
echo ==========================================
set /p this-is-the-only-way-to-have-the-script-frezze=CMD Store V%ver% has encountered an error.
goto show_error