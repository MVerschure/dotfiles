#!/bin/bash

DOTFILES=$HOME/dotfiles

cd $DOTFILES

git submodule init
git submodule update

cd $HOME

# spacevim setup
ln -sf $DOTFILES/SpaceVim $HOME/.vim
ln -sf $DOTFILES/.SpaceVim.d $HOME/

# setup git
ln -sf $DOTFILES/.gitconfig $HOME/
ln -sf $DOTFILES/.gitexcludes $HOME/

# oh-my-bash & plugins
cat $DOTFILES/.bashrc >> $HOME/.bashrc
ln -sf $DOTFILES/.aliases $HOME/
ln -sf $DOTFILES/.oh-my-bash $HOME/

# setup ble.sh
sudo apt-get update
sudo apt-get install -y gawk
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=$HOME/.local

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y
mkdir -p $HOME/.config
ln -sf $DOTFILES/starship.toml $HOME/.config/
rm -f starship.sh
