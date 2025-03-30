@echo off
title Erase.cmd
chcp 65001 >nul
color 03

:: Gerar ID único para o log
set "logID=%RANDOM%%RANDOM%"
set "logFile=%USERPROFILE%\Documents\log_%logID%.txt"
set "logFileDesktop=%USERPROFILE%\Desktop\log_%logID%.txt"

:: Criar ou limpar o arquivo de log
echo Log ID: %logID% > "%logFile%"
echo Log ID: %logID% > "%logFileDesktop%"

:start
cls
call :banner

:: Registrar no log
echo [%date% %time%] Iniciando o script. >> "%logFile%"
echo [%date% %time%] Iniciando o script. >> "%logFileDesktop%"

:menu
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo.
echo.
echo [38;2;0;179;255m           ╔═(1) Clear Cache [0m  
echo [38;2;0;168;255m           ║[0m  
echo [38;2;0;158;255m           ╠══(2) Clear Cookies[0m  
echo [38;2;0;147;255m           ║[0m  
echo [38;2;0;136;255m           ╠═══(3) Clear Logs[0m  
echo [38;2;0;125;255m           ║[0m  
echo [38;2;0;114;255m           ╚╦═══(4) Clear Journal Trace[0m  
echo [38;2;0;103;255m            ║[0m  
echo [38;2;0;92;255m            ╚╦═══(5) Clear DNS[0m
set /p choice=.%BS% [38;2;0;92;255m            ╚══════^>[0m  
if "%choice%"=="1" goto :CLEAR_CACHE
if "%choice%"=="2" goto :CLEAR_COOKIES
if "%choice%"=="3" goto :CLEAR_LOGS
if "%choice%"=="4" goto :JOURNAL_TRACE
if "%choice%"=="5" goto :CLEAR_DNS
cls
goto start

:CLEAR_CACHE
cls
call :banner
REM ******************** LIXEIRA ********************
del c:\$recycle.bin\* /s /q
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false >$null
del $null

REM ******************** PASTA TEMP DOS USUÁRIOS ********************

REM Apaga todos arquivos da pasta Temp de todos os usuários
for /d %%F in (C:\Users\*) do (Powershell.exe Remove-Item -Path "%%F\AppData\Local\Temp\*" -Recurse -Force)

REM cria arquivo vazio.txt dentro da pasta Temp de todos usuários
for /d %%F in (C:\Users\*) do type nul >"%%F\Appdata\Local\Temp\vazio.txt"

REM apaga todas as pastas vazias dentro da pasta Temp de todos usuários (mas não apaga a própria pasta Temp)
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Temp\ %%F\AppData\Local\Temp\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM Apaga arquivo vazio.txt dentro da pasta Temp de todos usuários
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Temp\vazio.txt

REM ******************** WINDOWS TEMP ********************

REM Apaga todos arquivos da pasta \Windows\Temp, mantendo das pastas
del c:\Windows\Temp\* /s /q

REM cria arquivo vazio.txt dentro da pasta \Windows\Temp
type nul > c:\Windows\Temp\vazio.txt

REM apaga todas as pastas vazias dentro da pasta \Windows\Temp (mas não apaga a própria pasta)
robocopy c:\Windows\Temp c:\Windows\Temp /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM Apaga arquivo vazio.txt dentro da pasta \Windows\Temp
del c:\Windows\Temp\vazio.txt

REM ******************** ARQUIVOS DE LOG DO WINDOWS ********************
del C:\Windows\Logs\cbs\*.log
del C:\Windows\setupact.log
attrib -s c:\windows\logs\measuredboot\*.*
del c:\windows\logs\measuredboot\*.log
attrib -h -s C:\Windows\ServiceProfiles\NetworkService\
attrib -h -s C:\Windows\ServiceProfiles\LocalService\
del C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\MpCmdRun.log
del C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp\MpCmdRun.log
attrib +h +s C:\Windows\ServiceProfiles\NetworkService\
attrib +h +s C:\Windows\ServiceProfiles\LocalService\
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\*.log /s /q
del C:\Windows\Logs\MeasuredBoot\*.log 
del C:\Windows\Logs\MoSetup\*.log
del C:\Windows\Panther\*.log /s /q
del C:\Windows\Performance\WinSAT\winsat.log /s /q
del C:\Windows\inf\*.log /s /q
del C:\Windows\logs\*.log /s /q
del C:\Windows\SoftwareDistribution\*.log /s /q
del C:\Windows\Microsoft.NET\*.log /s /q

REM ******************** ARQUIVOS DE LOG DO ONEDRIVE ********************
taskkill /F /IM "OneDrive.exe"
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\setup\logs\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\*.odl /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\*.aodl /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\*.otc /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\OneDrive\*.qmlc /s /q

REM ******************** ARQUIVOS DE DUMP DE PROGRAMAS (NÃO DO WINDOWS) ********************
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\CrashDumps\*.dmp /s /q

REM ******************** ARQUIVOS DE LOG DO WINDOWS E IE ********************
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\*.db /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\WebCache\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\SettingSync\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\"Terminal Server Client"\Cache\*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\IE\* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.dat /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.js /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.htm /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.txt /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.jpg /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Windows\INetCache\IE\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM ******************** EDGE ********************
taskkill /F /IM "msedge.exe"

for /d %%F in (C:\Users\*) do attrib -h -s %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content\*.*
for /d %%F in (C:\Users\*) do attrib -h -s %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\MetaData\*.*
for /d %%F in (C:\Users\*) do del %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\MetaData\*.* /s /q
for /d %%F in (C:\Users\*) do attrib +h +s %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content
for /d %%F in (C:\Users\*) do attrib +h +s %%F\AppData\LocalLow\Microsoft\CryptnetUrlCache\MetaData
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\Cache\Cache_Data\data*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\Cache\Cache_Data\data*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\Cache\Cache_Data\f*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\Cache\Cache_Data\f*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\Cache\Cache_Data\index. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\Cache\Cache_Data\index. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\GPUCache\d*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\GPUCache\d*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\GPUCache\i*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\GPUCache\i*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb\*.* /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb\*.* /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Code Cache"\js\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Code Cache"\js\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Code Cache"\wasm\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Code Cache"\wasm\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Platform Notifications"\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Platform Notifications"\*.* /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Platform Notifications"\*.* /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgePushStorageWithWinRt\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\EdgePushStorageWithWinRt\*.log /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\EdgePushStorageWithWinRt\*.log /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"File System"\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"File System"\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"File System"\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\*. /s /q)
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Service Worker"\Database\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Service Worker"\Database\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\"Service Worker"\ScriptCache\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\"Service Worker"\ScriptCache\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.ldb /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\EdgeCoupons\coupons_data.db\*.ldb /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\EdgeCoupons\coupons_data.db\*.ldb /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\EdgeCoupons\coupons_data.db\index. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\EdgeCoupons\coupons_data.db\index. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Guest Profile"\EdgeCoupons\coupons_data.db\*.log /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\"Profile %%i"\EdgeCoupons\coupons_data.db\*.log /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\BrowserMetrics\*.pma /s /q

REM ******************** FIREFOX ********************
taskkill /F /IM "firefox.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\script*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\startup*.* /s /q

REM ******************** CHROME ********************
taskkill /F /IM "chrome.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\Cache\Cache_Data\data*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\Cache\Cache_Data\data*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\Cache\Cache_Data\f*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\Cache\Cache_Data\f*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\Cache\Cache_Data\index. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\Cache\Cache_Data\index. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\GPUCache\d*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\GPUCache\d*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\GPUCache\i*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\GPUCache\i*. /s /q)
del C:\Program Files\Google\Chrome\Application\SetupMetrics\*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Code Cache"\js\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Code Cache"\js\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Code Cache"\wasm\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Code Cache"\wasm\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Storage\data_*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\Storage\data_*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\Storage\data_*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\JumpListIconsRecentClosed\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\JumpListIconsRecentClosed\*.tmp /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\JumpListIconsRecentClosed\*.tmp /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Storage\index*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\Storage\index*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\Storage\index*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\History-journal*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\History-journal*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\History-journal*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\webui_js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Code Cache"\webui_js\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Code Cache"\webui_js\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\Database\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Service Worker"\Database\*.log /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\Database\*.log /s /q)
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Google\Chrome\"User Data"\"Profile 1"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Service Worker"\Database\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\Database\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Guest Profile"\"Service Worker"\ScriptCache\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\"Profile %%i"\"Service Worker"\ScriptCache\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\BrowserMetrics*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\crash*.pma /s /q

REM ******************** BRAVE ********************
taskkill /F /IM "brave.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\GPUCache\i*. /s /q
del C:\Program Files\BraveSoftware\Brave-Browser\Application\SetupMetrics\*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Storage\data_*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\Storage\data_*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\JumpListIconsRecentClosed\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\JumpListIconsRecentClosed\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Storage\index*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\Storage\index*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\History-journal*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\History-journal*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\webui_js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Code Cache"\webui_js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\Database\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Service Worker"\Database\*.log /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\ %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Profile 1"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\"Guest Profile"\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\BrowserMetrics*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\crash*.pma /s /q

REM ******************** VIVALDI ********************
taskkill /F /IM "vivaldi.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\Cache\Cache_Data\data*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\Cache\Cache_Data\data*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\Cache\Cache_Data\f*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\Cache\Cache_Data\f*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\Cache\Cache_Data\index. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\Cache\Cache_Data\index. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\GPUCache\d*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\GPUCache\d*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\GPUCache\i*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\GPUCache\i*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Code Cache"\js\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Code Cache"\js\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Code Cache"\wasm\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Code Cache"\wasm\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Storage\data_*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\Storage\data_*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\Storage\data_*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\JumpListIconsRecentClosed\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\JumpListIconsRecentClosed\*.tmp /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\JumpListIconsRecentClosed\*.tmp /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Storage\index*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\Storage\index*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\Storage\index*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\History-journal*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\History-journal*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\History-journal*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\webui_js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Code Cache"\webui_js\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Code Cache"\webui_js\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\Database\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Service Worker"\Database\*.log /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\Database\*.log /s /q)
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Vivaldi\"User Data"\"Profile 1"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Service Worker"\Database\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\Database\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Guest Profile"\"Service Worker"\ScriptCache\*. /s /q
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\"Profile %%i"\"Service Worker"\ScriptCache\*. /s /q)
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\BrowserMetrics*.pma /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\crash*.pma /s /q

REM ******************** SPOTIFY ********************
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Spotify\Data\*.file /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Spotify\Browser\Cache\"Cache_Data"\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Spotify\Browser\GPUCache\*. /s /q

REM ******************** ADOBE MEDIA CACHE FILES ********************
for /d %%F in (C:\Users\*) do del %%F\AppData\Roaming\Adobe\Common\"Media Cache files"\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Roaming\Adobe\*.log /s /q

REM ******************** VMWARE ********************
del C:\ProgramData\VMware\logs\*.log /s /q

REM ******************** TeamViewer ********************
for /l %%i in (1,1,12) do (for /d %%F in (C:\Users\*) do del %%F\AppData\Local\TeamViewer\EdgeBrowserControl\Persistent\data_*.  /s /q)
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_0 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_1 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_2 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_3 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_4 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /S /M *_5 /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /M "f_*." /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /M "data.*" /C "cmd /c del @path"))
for /d %%u in (C:\Users\*) do (if exist "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" (forfiles /P "%%u\AppData\Local\TeamViewer\EdgeBrowserControl" /M "index.*" /C "cmd /c del @path"))

:: Registrar no log
echo [%date% %time%] Iniciando limpeza de cache... >> "%logFile%"
echo [%date% %time%] Iniciando limpeza de cache... >> "%logFileDesktop%"

:: Adicione os comandos para limpar o cache aqui.
echo Cache cleared!

:: Registrar no log
echo [%date% %time%] Cache limpo! >> "%logFile%"
echo [%date% %time%] Cache limpo! >> "%logFileDesktop%"

pause
goto start

:CLEAR_COOKIES
cls
call :banner
echo Clearing cookies...

:: Registrar no log
echo [%date% %time%] Iniciando limpeza de cookies... >> "%logFile%"
echo [%date% %time%] Iniciando limpeza de cookies... >> "%logFileDesktop%"

:: Excluindo arquivos relacionados ao Steam
echo Deletando arquivos de logs e cache do Steam...
del /q /f "C:\Program Files (x86)\Steam\logs\*"
del /q /f "C:\Program Files (x86)\Steam\config\*"
del /q /f "C:\Program Files (x86)\Steam\depotcache\*"
del /q /f "C:\Program Files (x86)\Steam\steam\cached\*"

:: Registrar no log
echo [%date% %time%] Arquivos de log e cache do Steam deletados! >> "%logFile%"
echo [%date% %time%] Arquivos de log e cache do Steam deletados! >> "%logFileDesktop%"

:: Excluindo logs do RIOT Vanguard
echo Deletando arquivos de logs do Riot Vanguard...
del /q /f "C:\Program Files\Riot Vanguard\Logs\*"

:: Registrar no log
echo [%date% %time%] Arquivos de log do Riot Vanguard deletados! >> "%logFile%"
echo [%date% %time%] Arquivos de log do Riot Vanguard deletados! >> "%logFileDesktop%"

:: Verificando e excluindo possíveis arquivos de login do Steam
echo Deletando arquivos de login do Steam...
del /q /f "C:\Program Files (x86)\Steam\userdata\*\*\steam.conf"
del /q /f "C:\Program Files (x86)\Steam\userdata\*\*\loginusers.vdf"

:: Registrar no log
echo [%date% %time%] Arquivos de login do Steam deletados! >> "%logFile%"
echo [%date% %time%] Arquivos de login do Steam deletados! >> "%logFileDesktop%"

:: Excluindo logs da Roblox
echo Deletando arquivos de logs da Roblox...
del /q /f "C:\Users\User\AppData\Local\Roblox\LocalStorage*"
del /q /f "C:\Users\User\AppData\Local\Roblox\Downloads\roblox-player*"
del /q /f "C:\Users\User\AppData\Local\Roblox\logs*"

:: Registrar no log
echo [%date% %time%] Arquivos de log da Roblox deletados! >> "%logFile%"
echo [%date% %time%] Arquivos de log da Roblox deletados! >> "%logFileDesktop%"

:: Verificando e excluindo arquivos de login do Riot
echo Deletando arquivos de login do Riot...
del /q /f "C:\Program Files\Riot Games\League of Legends\Config\game.cfg"
del /q /f "C:\Program Files\Riot Games\League of Legends\Config\user.cfg"

:: Registrar no log
echo [%date% %time%] Arquivos de login do Riot deletados! >> "%logFile%"
echo [%date% %time%] Arquivos de login do Riot deletados! >> "%logFileDesktop%"

echo Cookies cleared!

:: Registrar no log
echo [%date% %time%] Cookies limpos! >> "%logFile%"
echo [%date% %time%] Cookies limpos! >> "%logFileDesktop%"

pause
goto start

:CLEAR_LOGS
cls
call :banner
:: Verifica se o script está sendo executado como administrador
FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin

:: Limpa todos os logs de eventos
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (
    call :do_clear "%%G"
)

:: Registrar no log
echo [%date% %time%] Limpeza de logs de eventos concluída. >> "%logFile%"
echo [%date% %time%] Limpeza de logs de eventos concluída. >> "%logFileDesktop%"

echo.
echo Todos os logs de eventos foram apagados!
pause
goto start

:do_clear
echo Limpando %1
wevtutil.exe cl %1

:: Registrar no log
echo [%date% %time%] Log %1 deletado! >> "%logFile%"
echo [%date% %time%] Log %1 deletado! >> "%logFileDesktop%"

goto :eof

:noAdmin
cls
call :banner
echo As permissões do usuário atual para executar este arquivo .BAT são inadequadas.
echo Este arquivo .BAT deve ser executado com privilégios administrativos.
echo Saia agora, clique com o botão direito neste arquivo .BAT e selecione "Executar como administrador".
pause >nul
goto start

:invalidOption
cls
call :banner
echo Opção inválida. Por favor, escolha 1, 2, 3, 4 ou 5.
pause >nul
goto start

:JOURNAL_TRACE
cls
call :banner
fsutil usn deletejournal /D /C:
cls
goto start

:CLEAR_DNS
cls
call :banner
echo Limpando o cache DNS, liberando e renovando o IP...
echo.

:: Limpa o cache DNS
ipconfig /flushdns
echo Cache DNS limpo!

:: Liberar e renovar o endereço IP
ipconfig /release
echo Endereço IP liberado!
ipconfig /renew
echo Endereço IP renovado!

:: Resetar o TCP/IP
netsh int ip reset
echo TCP/IP resetado!

:: Resetar o Winsock
netsh winsock reset
echo Winsock resetado!

:: Registrar no log
echo [%date% %time%] Cache DNS, IP liberado e renovado. TCP/IP e Winsock resetados. >> "%logFile%"
echo [%date% %time%] Cache DNS, IP liberado e renovado. TCP/IP e Winsock resetados. >> "%logFileDesktop%"

echo.
pause
goto start

:banner
echo.
echo.
echo Log ID: %logID%
echo.
echo [38;2;0;179;255m ███████╗██████╗  █████╗ ███████╗███████╗[0m
echo [38;2;0;168;255m ██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝[0m
echo [38;2;0;158;255m █████╗  ██████╔╝███████║███████╗█████╗[0m  
echo [38;2;0;147;255m ██╔══╝  ██╔══██╗██╔══██║╚════██║██╔══╝[0m  
echo  [38;2;0;136;255m███████╗██║  ██║██║  ██║███████║███████╗[0m
echo  [38;2;0;125;255m╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝[0m
echo.
