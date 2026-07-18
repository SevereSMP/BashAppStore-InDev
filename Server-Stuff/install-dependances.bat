@echo off
echo opening some urls
start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-setup.exe
start http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-src-setup.exe
timeout /t 6
cd Downloads
echo installing wget
if exist wget-1.11.4-setup.exe (
   start "wget-1.11.4-setup.exe" 
)
if exist wget-1.11.4-1-src-setup.exe (
    start "wget-1.11.4-1-src-setup.exe"
)
echo installing mysql
