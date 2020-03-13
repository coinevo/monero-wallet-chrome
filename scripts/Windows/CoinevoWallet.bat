REM Coinevo coinevo-wallet-cli Launcher, (c) 2016 bigreddmachine.
REM https://github.com/coinevo/coinevo-wallet-chrome
REM
REM This script allows coinevo-wallet-cli to be run in rpc mode easily and quickly. User passwords
REM are secured by passing them as a terminal input, rather than requiring them to be stored
REM as clear text in the script.
REM
REM This script is released under the MIT License.

@echo off
cls
set WALLET_FILENAME=wallet.bin
set PROGRAM_DIR=C:\Program Files\CoinevoWallet

echo.
echo ====================================================================================
echo                    Coinevo coinevo-wallet-cli Launcher for Windows
echo.
echo Copyright (c) 2016 bigreddmachine.
echo Released under the MIT License as part of Coinevo Wallet for Chrome.
echo https://github.com/coinevo/coinevo-wallet-chrome
echo ====================================================================================
echo.

set WALLET_DIR=%PROGRAM_DIR%\wallet
IF not exist %WALLET_DIR% (mkdir %WALLET_DIR%)
set FILE=%WALLET_DIR%\%WALLET_FILENAME%

echo Which Coinevo daemon would you like to connect to?
echo   1. remote (mobile3.coinevo.tech:33330)
echo   2. local  (127.0.0.1:33331)
echo   3. custom
echo.
set /p DAEMON=Please make a selection:

if NOT %DAEMON% == 1 if NOT %DAEMON% == 2 if NOT %DAEMO% == 3 (
    set -p exitinput=Invalid daemon selection. Press enter to quit.
    exit
)

if %DAEMON% == 1 (
    set USE_DAEMON=mobile3.coinevo.tech:33330
)
if %DAEMON% == 2 (
    set USE_DAEMON=127.0.0.1:33331
)
if %DAEMON% == 3 (
    set /p USE_DAEMON=Please enter custom daemon (ex: 192.168.0.1:33331):
)

echo.
echo ----------------------
echo.


if exist %FILE% (
    REM If this script has been run previously, a wallet should already exist. Start it in RPC mode.

    echo Launching coinevo-wallet-cli in RPC mode, listening on localhost (127.0.0.1), port 33332.
    echo.
    set /p PASS=Please enter your password:

    echo.
    echo Choose a User Agent. You can use a new User Agent each time you use your wallet.
    set /p USERAGENT=Please enter a User Agent:

    echo Launching coinevo-wallet-cli...
    echo.

    start "%PROGRAM_DIR%\coinevo-wallet-cli --wallet-file %FILE% --password %PASS% --user-agent %USERAGENT% --rpc-bind-ip 127.0.0.1 --rpc-bind-port 33332 --daemon-address %USE_DAEMON%"

    echo coinevo-wallet-cli should now be running in RPC mode. You can verify this by checking if
    echo your Chrome extension says "online". It may take a few seconds for the wallet to
    echo connect to coinevo-wallet-cli. If it fails to come online, please check your password
    echo and user agent and try again.
    echo.
    echo To shutdown coinevo-wallet-cli, choose 'Stop Wallet' in the extension's menu.
    echo.
    echo Thank you for using Coinevo Wallet for Chrome! You may now close this window.
    echo.

) else (
    REM The first time this script is run, open the command line wallet.

    echo You have not created a wallet yet. This script will help you do that.
    echo.
    echo To create a wallet, follow the prompts. Enter a password, then pick a
    echo language for your wallet.
    echo.
    echo Once you have created a wallet, coinevo-wallet-cli will open and a prompt
    echo line will appear. Type 'refresh', then once it is done type 'exit'.
    echo You are then ready to use Coinevo Wallet for Chrome.
    echo.

    set /p userinput=When you are ready to begin, press enter...

    echo.
    echo ----------
    set /p NEWPASS=Please pick a password for your new wallet:
    echo.
    set /p CONFIRM_NEWPASS=Confirm password:
    if NOT %NEWPASS% == %CONFIRM_NEWPASS% (
        echo Your passwords do not match. Please restart the script and try again.
        echo.
        set /p userinput=Press "enter" to exit.
        exit
    )
    echo ----------
    echo.

    %PROGRAM_DIR%\coinevo-wallet-cli --generate-new-wallet %FILE% --password %NEWPASS%  --daemon-address %USE_DAEMON%

    echo.
    echo ----------
    echo.

    if exist %FILE% (
        echo Everything looks good. You can now start your wallet in RPC mode at any time by re-running this script.
        echo.
        set /p userinput=Press "enter" to exit Coinevo coinevo-wallet-cli Launcher.
    ) else (
        echo There seems to have been an issue creating your wallet.
        echo.
        set /p userinput=Press "enter" to exit.
    )
)

echo.
