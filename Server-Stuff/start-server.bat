@echo off

::Run Some Checks
if /i not "%CMDSI%"=="installed" (
    title CMDStore_server_v%CMDSV%_ERROR_NOT_INSTALLED
    echo CMDStore Server is not installed. Please run the installer first.
    pause
    exit /b
)

:topofthemorningtoya
title CMDStore_Server_v%CMDSV%
echo ==================================
echo CMDStore Server v%CMDSV%
echo ==================================

echo .
echo ==================================
echo 1. Start CMDStore Server v%CMDSV%
echo 2. Open the Install folder
echo 3. Enter Server Tool Box This WILL NOT Work (Make Sure You Have The Server Running In A Diffrent Window)
echo 4. Exit
echo ==================================

set /p "user_sel=Enter a number (1-4): "


::See wth the user pressed
if %user_sel% equ 1 (
    goto start_server
)

if %user_sel% equ 2 (
    explorer %store_path%
)

if %user_sel% equ 3 (
    goto server_box
)

if %user_sel% equ 4 (
    exit
)

echo 
:: Main Codes


:start_server
:: Do Some decoration
cls
title CMDStore_Server_v%CMDSV%_Running_Server
cd %store_path%
echo ==========================================
echo CMDStore Server v%CMDSV% (Running)
echo URL: http://%phpsip%
echo ==========================================

php -S %phpsip%
cls
echo PHP Crashed!!!!!!
goto topofthemorningtoya

:server_box
cls
title CMDStore_Server_v%CMDSV%_Server_Tool_Box

cd %store_path%

echo ==============================
echo Server Tool Box (This stuff is in BETA so it might (aka probably) not work!)
echo ==============================
echo 1. Open PHPMyAdmin
echo 2. Open API Tester
echo 3. Open The Database Config File
echo 4. Open CDN Folder
echo b. Goto Main Menu
echo ==============================

set /p "cur_tool=Enter a number (1-4) or b: "

::see wth the user pressed
if %cur_tool% equ 1 (
    cls
    start http://%phpsip%/tools/pma
    echo Opened phpMyAdmin
    goto server_box
)

if %cur_tool% equ 2 (
    cls
    start http://%phpsip%/tools/API-TEST
    echo Opened API TESTER
)

if %cur_tool% equ 3 (
    cd %store_path%\api
    notepad db_config.php
    cd %store_path%
    goto server_box
)

if %cur_tool% equ 4 (
    explorer %server_path%\CDN
    cls
    goto server_box
)

if %cur_tool% equ b (
    cls
    goto topofthemorningtoya
)

