#!/bin/bash

# Only supports Ubuntu 22.04, 20.04, and 18.04
case $(grep -E '^(UBUNTU_CODENAME)=' /etc/os-release) in
    UBUNTU_CODENAME=jammy)
        VERSION_ID=22.04
        ;; 
    UBUNTU_CODENAME=focal)
        VERSION_ID=20.04
        ;;
    UBUNTU_CODENAME=bionic)
        VERSION_ID=18.04
        ;;
    *)
        echo "Unsupported operating system"
        exit
        ;;
esac

echo "Installing as Ubuntu $VERSION_ID"

mkdir ~/eos
mkdir ~/eos/temp

wget https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu${VERSION_ID}_amd64.deb \
    -O ~/eos/temp/leap_4.0.1-ubuntu${VERSION_ID}_amd64.deb
wget https://github.com/AntelopeIO/cdt/releases/download/v3.1.0/cdt_3.1.0_amd64.deb \
    -O ~/eos/temp/cdt_3.1.0_amd64.deb
sudo apt-get install -y ~/eos/temp/cdt_*.deb ~/eos/temp/leap_*.deb

echo nodeos
nodeos --version
echo cdt
cdt-cpp --version

# install contract build prerequisites
sudo apt-get update
sudo apt-get install -y build-essential clang clang-tidy cmake git libxml2-dev opam ocaml-interp python3 python3-pip time curl
# download contract release
wget https://github.com/eosnetworkfoundation/eos-system-contracts/archive/refs/tags/v3.1.1.tar.gz \
    -O ~/eos/temp/eos-system-contracts_v3.1.1.tar.gz
rm -fdr ~/eos/temp/eos-system-contracts-3.1.1 #remove existing 
tar xf ~/eos/temp/eos-system-contracts_v3.1.1.tar.gz --directory ~/eos/temp/
cd ~/eos/temp/eos-system-contracts-3.1.1/ 
./build.sh

#screen is used to run nodeos in the background
sudo apt-get install -y screen
mkdir ~/eos/data-dir
mkdir ~/eosio-wallet
cp -r ~~/eos/temp/eos-system-contracts-3.1.1/build/contracts ~/eos/
wget https://gist.githubusercontent.com/jimmckeeth/4355a024f23192b1a6a046cc09231cdc/raw/bootup.sh \
    -O ~/eos/bootup.sh
chmod +x ~/eos/bootup.sh
wget https://gist.github.com/jimmckeeth/34ca8a049a39c4f917fdc60021422137/raw/config.ini \
    -O ~/eos/data-dir/config.ini
cd ~/eos