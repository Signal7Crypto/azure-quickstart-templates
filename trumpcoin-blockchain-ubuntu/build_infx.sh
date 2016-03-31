#!/bin/bash

set -e 

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running TrumpCoin #
#################################################################
sudo apt-get update
#################################################################
# Build TrumpCoin from source                                   #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building TrumpCoin         #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/TrumpCoin
if [ ! -e "$file" ]
then
	sudo git clone https://github.com/TRUMPCOIN/TRUMP TrumpCoin
fi

cd /usr/local/TrumpCoin/src
file=/usr/local/TrumpCoin/src/TrumpCoind
if [ ! -e "$file" ]
then
	sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/TrumpCoin/src/Trumpcoind /usr/bin/Trumpcoind

################################################################
# Configure to auto start at boot		                           #
################################################################
file=$HOME/.TrumpCoin
if [ ! -e "$file" ]
then
	sudo mkdir $HOME/.TrumpCoin
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.TrumpCoin/TrumpCoin.conf
file=/etc/init.d/TrumpCoin
if [ ! -e "$file" ]
then
	printf '%s\n%s\n' '#!/bin/sh' 'sudo TrumpCoin' | sudo tee /etc/init.d/TrumpCoin
	sudo chmod +x /etc/init.d/TrumpCoin
	sudo update-rc.d TrumpCoin defaults	
fi

/usr/bin/TrumpCoin
echo "TrumpCoin has been setup successfully and is running..."
exit 0
