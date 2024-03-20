#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

cd $DOTFILES_DIR

git submodule init
git submodule update

sudo apt-get update
sudo apt-get install stow wget unzip -y
mkdir -p $HOME/.config
stow -v --adopt --dir $DOTFILES_DIR --target $HOME --stow my-home
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --stow starship
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.oh-my-zsh/custom/plugins/ --restow zsh
# if the stow adopt made a local change then undo that
git checkout HEAD -- starship my-home

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv
rm -f DroidSansMono.zip

curl -sS https://starship.rs/install.sh -o starship.sh
chmod +x starship.sh
sudo ./starship.sh -y
rm -f starship.sh

sudo apt-get install -y fzf
