#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo -e "${RED} ███████ ▓█████▄▄▄█████▓ █   ██  ██▓███  " 
echo -e "${RED}▒██    ▒ ▓█   ▀▓  ██▒ ▓▒ ██  ▓██▒▓██░  ██▒" 
echo -e "${RED}░ ▓██▄   ▒███  ▒ ▓██░ ▒░▓██  ▒██░▓██░ ██▓▒" 
echo -e "${RED}  ▒   ██▒▒▓█  ▄░ ▓██▓ ░ ▓▓█  ░██░▒██▄█▓▒ ▒" 
echo -e "${RED}▒██████▒▒░▒████▒ ▒██▒ ░ ▒▒█████▓ ▒██▒ ░  ░" 
echo -e "${RED}▒ ▒▓▒ ▒ ░░░ ▒░ ░ ▒ ░░   ░▒▓▒ ▒ ▒ ▒▓▒░ ░  ░" 
echo -e "${RED}░ ░▒  ░ ░ ░ ░  ░   ░    ░░▒░ ░ ░ ░▒ ░     " 
echo -e "${RED}░  ░  ░     ░    ░      ░░░ ░ ░ ░░        " 
echo -e "${RED}     ░     ░  ░         ░            ${ENDCOLOR}   " 
                                          
echo ""                                         
echo -e "\e[1;34m[*] \e[32mInstalling Requirements\e[0m"   

# Clean old ruby gems to prevent conflicts
apt purge ruby -y
rm -fr $PREFIX/lib/ruby/gems

pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo "*** Installing binutils and dependencies..."

pkg install -y binutils python git autoconf bison clang coreutils curl findutils \
apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc \
libtool libxml2 libxslt ncurses make ncurses-utils wget unzip zip tar termux-tools \
termux-elf-cleaner pkg-config ruby libyaml espeak nodejs -o Dpkg::Options::="--force-confnew"

# Upgrade pip and install requests
python3 -m pip install --upgrade pip
python3 -m pip install requests

echo "*** Downloading BeEF..."
cd $HOME

# Remove existing directory if reinstalling
if [ -d "beef" ]; then
    rm -rf beef
fi

git clone https://github.com/beefproject/beef --depth=1
cd $HOME/beef

# Install ruby dependencies
gem install bundler
NOKOGIRI_USE_SYSTEM_LIBRARIES=1 gem install nokogiri -- --use-system-libraries

# Patching the install script to remove sudo requirements for Termux
sed -i 's/sudo //g' install

# Run the installer
bash install

echo -e "\e[1;34m[*] \e[32mSetup Complete.\e[0m"
