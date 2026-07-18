@echo off
echo ==========================================
echo Welcome to the CMD Store Server!
echo ==========================================

choice /c YN /m "Is This Script Running As Admin? (you need to have this running as admin for MySQL Install)"
:: Ensure the script runs with Administrative privileges before continuing
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    title CMDStore_Server_ERROR_NO_ADMIN
    echo This installation script must be Run as Administrator!
    pause
    exit /b 1
)

set /p store_path=Enter The Path to the CMD Store (e.g., C:\CMDStore):

if not exist "%store_path%" (
    echo The specified path does not exist. Please check the path and try again.
    pause
    exit /b
)

cls
echo ==========================================
echo Welcome to the CMD Store Server! (Askin Time)
echo ==========================================

echo .

echo Make Sure the path is like this C:\path\to\CMDStore NOT C:/path/to/CMDStore
echo CMDStore install path: %store_path%
choice /c YN /m "Is this the correct path to the CMD Store?"

if errorlevel 2 (
    echo Please restart the script and enter the correct path.
    pause
    exit /b
)
echo . 
echo .
choice /c YN /m "Are you fine with downloading PHP?"

if errorlevel 2 (
    echo You must download PHP please restart the script.
    echo if you dont have php the CMDStore will not work at all.
    pause
    exit /b
)

echo .
echo .


choice /c YN /m "Are You Fine With Downloading MySQL?"
if errorlevel 2 (
    echo CMDStore Server will not work without MySQL please restart the script and choose to download MySQL.
    exit /b
)


echo .
echo .

choice /c YN /m "Are you sure you want to continue this will download PHP and core server files? "

if errorlevel 2 (
    echo Installation aborted. Please restart the script if you wish to install the CMD Store server.
    pause
    exit /b
)
cls
echo ==========================================
echo Welcome to the CMD Store Server! (Installin Time)
echo ==========================================


echo Downloading PHP...
:: Download PHP
winget install PHP.PHP.8.5
echo Done!
echo .

echo Downloading MySQL...
:: Download MySQL
winget install Oracle.MySQL

echo Running MySQL Batch Setup script

:: Ensure the script runs with Administrative privileges before continuing
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] This installation script must be Run as Administrator!
    pause
    exit /b 1
)

echo [1/3] Triggering silent MySQL Server installation and background configuration...

:: Define your project-specific configurations here
set "DB_PASSWORD=BashAppStoreMySQL"
set "DB_PORT=3306"

:: Execute the console installer directly with standard configuration keypairs
"C:\\Program Files (x86)\\MySQL\\MySQL Installer\\MySQLInstallerConsole.exe" community install server;8.0*;*X64:port=%DB_PORT%;passwd=%DB_PASSWORD%;autostartservice=true;openfirewall=true --silent

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] MySQL Installer Console failed to execute properly.
    exit /b %ERRORLEVEL%
)

echo [2/3] Adding MySQL binaries permanently to the Windows System PATH...
:: This globally registers the 'mysql' command line tool across the OS
setx /M PATH "%PATH%;C:\Program Files\MySQL\MySQL Server 8.0\bin"

echo [3/3] Verifying background system service status...
:: Ensure the newly generated Windows service is completely up and listening
net start MySQL80 >nul 2>&1

echo [SUCCESS] MySQL Server setup is complete! Root password is set up and service is active.
echo Saving The MySQL login info to %store_path%\MySQLInfo.txt
cd %server_path%
echo User Name: "root" Password: "BashAppStoreMySQL" > MySQLInfo.txt
echo Done!

echo Downloading CMD Store Core Files...
:: Download CMD Store Core Files
wget https://cmds.severesmp.org/store/CDN/Extra/CoreServer.zip -O "%store_path%\CoreServer.zip"
if %errorlevel% neq 0 (
    echo Failed to download CMD Store Core Files. Please check your internet connection and try again.
    pause
    exit /b
)
echo Extracting CMD Store Core Files...
:: Extract CMD Store Core Files
tar -xf "%store_path%\CoreServer.zip" -C "%store_path%"
echo Done!

echo i need your help for this one
pause
echo when prompted to type a Password Type this: BashAppStoreMySQL ok?
pause
mysql -u root -p < %store_path%\DB.sql




echo .
echo Doing some final setup...
:: Final setup steps

:: Do Some ENV setup

setx store_path "%store_path%"

setx CMDSI installed

setx CMDSV 1.0.0-PRE-APP

:: Create Configs
::PHP Server Config
setx phpsip localhost:80

::Make shortcut
wget https://github.com/SevereSMP/BashAppStore-InDev/raw/refs/heads/main/Server-Stuff/start-server.bat -O "%server_path%\start-server.bat"
mklink "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\CMDStore Server.lnk" "%server_path%\start-server.bat"

echo Installation completed successfully!
echo Open CMDStore Server In The Start Menu!
pause
echo Thank you :D :P
exit