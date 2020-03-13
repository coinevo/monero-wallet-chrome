#!/bin/bash

#
# Coinevo coinevo-wallet-cli Launcher, (c) 2016 bigreddmachine.
# https://github.com/coinevo/coinevo-wallet-chrome
#
# This script allows coinevo-wallet-cli to be run in rpc mode easily and quickly. User passwords
# are secured by passing them as a terminal input, rather than requiring them to be stored
# as clear text in the script.
#
# This script is released under the MIT License.
#

clear

echo "===================================================================================="
echo "                    Coinevo coinevo-wallet-cli Launcher for Linux"
echo ""
echo "Copyright (c) 2016 bigreddmachine."
echo "Released under the MIT License as part of Coinevo Wallet for Chrome."
echo "https://github.com/coinevo/coinevo-wallet-chrome"
echo "===================================================================================="
echo ""

mkdir -p ~/.CoinevoWalletChrome

sleep 1

cd ~/.CoinevoWalletChrome
FILE="wallet.bin"

echo "Which Coinevo daemon would you like to connect to?"
echo "  1. remote (mobile3.coinevo.tech:33330)"
echo "  2. local  (127.0.0.1:18081)"
echo "  3. custom"
echo ""
read -p "Please make a selection: " DAEMON

if [ $DAEMON -ne 1 ] && [ $DAEMON -ne 2 ] && [ $DAEMON -ne 3 ]; then
    read -p "Invalid daemon selection. Press enter to quit."
    exit
fi

if [ $DAEMON -eq 3 ]; then
    echo "Please enter custom daemon in quotes (example: \"192.168.0.1:33331\"):"
    read CUSTOM_DAEMON
fi

echo ""
echo "----------------------"
echo ""

if [ -f "$FILE" ]; then
    # If this script has been run previously, a wallet should already exist. Start it in RPC mode.
    echo "  Launching coinevo-wallet-cli in RPC mode, listening on localhost (127.0.0.1), port 33331."
    echo ""
    echo "  Please enter your password: "
    read -s PASS

    echo ""
    echo "  Choose a 'User Agent'. You can use a new User Agent each time you use your wallet."
    echo "  Please enter a User Agent: "
    read -s USER

    echo ""
    echo "  Launching coinevo-wallet-cli..."
    echo ""

    if [ $DAEMON -eq 1 ]; then
        screen -S CoinevoWalletCLIrpc -d -m ~/CoinevoWallet/coinevo-wallet-cli --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 33332 --daemon-address mobile3.coinevo.tech:33330
    elif [$DAEMON -eq 2 ]; then
        screen -S CoinevoWalletCLIrpc -d -m ~/CoinevoWallet/coinevo-wallet-cli --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 33332
    else
        screen -S CoinevoWalletCLIrpc -d -m ~/CoinevoWallet/coinevo-wallet-cli --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 33332 --daemon-address $CUSTOM_DAEMON
    fi

    sleep 1
    echo "----------------------"

    echo ""
    echo "  coinevo-wallet-cli should now running in RPC mode. If you have trouble logging into the extension, you may have typed the wrong password or wrong User Agent."
    echo ""
    echo "  When you access your wallet in the extension, your 'User Agent' acts as your login credentials. You can change a new User Agent each time your open your wallet."
    echo ""
    echo "  To shutdown coinevo-wallet-cli, choose 'Stop Wallet' in the extension's menu."
    echo ""
    read -p "  Thank you for using Coinevo Wallet for Chrome! Press 'enter' to close this dialog. coinevo-wallet-cli will continue running in the background."


else
    # The first time this script is run, open the command line wallet.
    echo "  You have not created a wallet yet. This script will help you do that."
    echo ""
    echo "  To create a wallet, follow the prompts. Enter a password, then pick a"
    echo "  language for your wallet."
    echo ""
    echo "  Once you have created a wallet, coinevo-wallet-cli will open and a prompt"
    echo "  line will appear. Type 'refresh', then once it is done type 'exit'."
    echo "  You are then ready to use Coinevo Wallet for Chrome."
    echo ""
    read -p "  When you are ready to begin, press enter... "

    echo ""
    echo "----------"
    echo "  Please pick a password for your new wallet: "
    read -s NEWPASS
    echo ""
    echo "  Confirm password: "
    read -s CONFIRM_NEWPASS
    echo ""

    if [ "$NEWPASS" != "$CONFIRM_NEWPASS" ]; then
        echo "  Your passwords do not match. Please restart the script and try again."
        echo ""
        read -p "  Press 'enter' to exit."
        exit
    fi

    echo "----------"
    echo ""

    if [ $DAEMON -eq 1 ]; then
        ~/CoinevoWallet/coinevo-wallet-cli --generate-new-wallet $FILE --password $NEWPASS --daemon-address mobile3.coinevo.tech:33331
    elif [ $DAEMON -eq 2 ]; then
        ~/CoinevoWallet/coinevo-wallet-cli --generate-new-wallet $FILE --password $NEWPASS
    else
        ~/CoinevoWallet/coinevo-wallet-cli --generate-new-wallet $FILE --password $NEWPASS --daemon-address $CUSTOM_DAEMON
    fi

    echo ""
    echo "----------"
    echo ""

    if [ -e "$FILE" ]; then
        echo "  Everything looks good. You can now start your wallet in RPC mode at any time by re-running this script."
        echo ""
        read -p "  Press 'enter' to close Coinevo coinevo-wallet-cli Launcher."
    else
        read -p "  There seems to have been an issue creating your wallet. Press 'enter' to close this dialog."
    fi
fi

echo ""
