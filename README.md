# CMD Store

![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-raw/SevereSMP/BashAppStore-InDev?style=plastic&link=https%3A%2F%2Fgithub.com%2FSevereSMP%2FBashAppStore-InDev%2Fissues)
![Static Badge](https://img.shields.io/badge/Made%20By%20-SevereSMP%20and%20James%20(aka%20SevereSMP)-blue?link=https%3A%2F%2Fgithub.com%2FSevereSMP)
#

CMD Store is a Windows batch-based launcher for fetching and installing applications from a remote store API.

## NOTE: ALL OF THIS IS INDEV SOME THINGS MAY NOT WORK!
## Repository Overview

- `main.bat` - main launcher script with menu, app list fetch, installer download, cleanup, and developer test options.
- `Server-Stuff/server.bat` - local server installer helper, downloads PHP/MySQL and CMD Store core files.
- `Server-Stuff/install-dependances.bat` - dependency helper for setting up `wget` and other tools.
- `Server-Stuff/start-server.bat` - script to start the local server environment.
- `CoreServer.zip` - compressed server resources to unpack if you want to run a local PHP backend.
- `README.md` - this documentation file.

## Requirements

- Windows environment with Command Prompt
- `wget` available on `PATH`
- A working store server with API endpoints:
  - `/api/get-list.php?page=...`
  - `/api/get-url.php?id=...` 
- `%TEMP%` writable for temporary downloads

## Current status

- `main.bat` is configured with `dev_mode=1` by default.
- The `store_url` in `main.bat` points to a live store at `cmds.severesmp.org/store`.
- The repo is under development, but the public store backend is now accessible.

## How to use

1. Open the project folder on a Windows machine.
2. Ensure `wget` is installed and available in Command Prompt.
3. To set up a local server environment, use `Server-Stuff/server.bat` or `Server-Stuff/start-server.bat`.
4. Run `main.bat` from Command Prompt or by double-clicking it.
5. Choose one of the main menu options:
   - `1` = open the store and view applications
   - `2` = clear old temporary install files
   - `3` = exit

## Developer mode options

When `dev_mode` is enabled, `main.bat` shows additional options:

- `61` = fetch the list of available applications from the API
- `62` = install an application without clearing the screen first

## Configuration

Edit the top of `main.bat` to change:

- `store_url` = base URL of the store server
- `dev_mode` = `1` for development/test mode, `0` for production use

## Temporary files

- Downloads are stored under `%TEMP%\CMDStoreInstall`
- Option `2` in the menu deletes the temporary installer directory

## Notes

- The launcher uses `wget` to request the store API and download installer files.
- The app list and installer URLs depend on the store backend being available.
- The local server helper scripts are in `Server-Stuff`.
- `Server-Stuff/server.bat` uses `winget` to install PHP and MySQL, so Windows package support is required.

## Planned improvements

- Make the local server setup easier to run (im working on this)
- Improve The App Catolog (im not working on this yet)
- Improve install logging and history tracking (im not working on this yet)
