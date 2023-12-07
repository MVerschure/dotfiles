#!/bin/bash
 
pkg install getconf termux-tools vim rsync openssh termux-api which -y

DOTFILES=$HOME/dotfiles

cd $DOTFILES

git submodule init
git submodule update

cd $HOME
mkdir -p $HOME/.termux

# termux settings
ln -sf $DOTFILES/termux.properties $HOME/.termux/termux.properties

# spacevim setup
ln -sf $DOTFILES/SpaceVim $HOME/.vim
ln -sf $DOTFILES/.SpaceVim.d $HOME/.SpaceVim.d

# setup git
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitexcludes $HOME/.gitexcludes

# oh-my-bash & plugins
cat $DOTFILES/.bashrc >> $HOME/.bashrc
ln -sf $DOTFILES/.aliases $HOME/.aliases
ln -sf $DOTFILES/.exports $HOME/.exports
ln -sf $DOTFILES/.oh-my-bash $HOME/.oh-my-bash

# setup starship
curl -sSL https://github.com/prateekpunetha/termux-setup/raw/main/fonts/font.ttf -o $HOME/.termux/font.ttf
termux-reload-settings

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
./starship.sh -y --bin-dir /data/data/com.termux/files/usr/bin
mkdir -p $HOME/.config
starship preset pastel-powerline > $HOME/.config/starship.toml
rm -f starship.sh

yes | pkg remove nano

