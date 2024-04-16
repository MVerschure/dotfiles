#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

cd $DOTFILES_DIR

#git submodule init
#git submodule update

sudo apt-get update
sudo apt-get install stow wget unzip -y

# Setup LVIM
# installing neovim
sudo add-apt-repository ppa:ppa-verse/neovim
sudo apt-get update
sudo apt-get install neovim

# Installing Lvim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

# Installing LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

mkdir -p $HOME/.config
stow -v --adopt --dir $DOTFILES_DIR --target $HOME --stow my_home
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --stow starship
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --stow config
#stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.oh-my-zsh/custom/plugins/ --restow zsh
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



#sudo apt-get install -y fzf

echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> $HOME/.bashrc
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
