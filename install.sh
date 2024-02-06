#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

cd $DOTFILES_DIR

git submodule init
git submodule update

sudo apt-get update
sudo apt-get install stow wget unzip -y
stow -v --adopt --dir $DOTFILES_DIR --target $HOME --stow my-home
# if the adopt made a local change then undo that
git checkout HEAD -- starship my-home

# setup ble.sh
sudo apt-get update
sudo apt-get install -y gawk
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=$HOME/.local
rm -rf ble.sh

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv
rm -f DroidSansMono.zip

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y
mkdir -p $HOME/.config
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --stow starship
rm -f starship.sh
