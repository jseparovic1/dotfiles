#!/bin/bash

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

# Install zsh
echo 'Install oh-my-zsh'
echo '-----------------'
rm -rf $HOME/.oh-my-zsh
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Add global gitignore
ln -s ./shell/.global-gitignore $HOME/.global-gitignore
git config --global core.excludesfile $HOME/.global-gitignore

# Symlink zsh prefs
rm $HOME/.zshrc
ln -s ./dotfiles/shell/.zshrc $HOME/.zshrc

echo 'Install composer'
echo '----------------'
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

echo 'Install homebrew'
echo '----------------'
echo install homebrew
sudo rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo 'Install pkg-config'
echo '------------------'
brew install pkg-config

echo 'Install wget'
echo '------------'
brew install wget --overwrite

echo 'Install brew-cask'
echo '-----------------'
brew tap caskroom/cask
brew install brew-cask

echo 'Install node'
echo '-----------'
brew install node@20

echo 'Install zsh-autosuggestions'
echo '---------------------------'
brew install zsh-autosuggestions

echo 'Symlink agent files into AI harnesses'
echo '-------------------------------------'
source "$(dirname "${BASH_SOURCE[0]}")/symlink-agents.sh"

echo '++++++++++++++++++++++++++++++'
echo 'All done!'
