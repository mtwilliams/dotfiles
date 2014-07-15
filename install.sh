#!/bin/bash

echo Setting up Sublime Text 3...
echo Make sure to install Pacakge Control,
echo  and to install "Theme - Spacegray"
echo  as well as "Base16 Color Schemes"

home=$HOME

sudo unlink $home/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
sudo rm $home/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
sudo ln -s `pwd`/sublime-text-3/Packages/User/Preferences.sublime-settings $home/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
sudo unlink $home/.config/sublime-text-3/Packages/sublime-c99
sudo ln -s `pwd`/sublime-text-3/Packages/sublime-c99 $home/.config/sublime-text-3/Packages/sublime-c99
sudo unlink $home/.config/sublime-text-3/Packages/sublime-cpp11
sudo ln -s `pwd`/sublime-text-3/Packages/sublime-cpp11 $home/.config/sublime-text-3/Packages/sublime-cpp11

echo Setting up Shell

sudo unlink $home/.gitconfig
sudo rm $home/.gitconfig
sudo ln -s `pwd`/.gitconfig $home/.gitconfig

sudo unlink $home/.hgrc
sudo rm $home/.hgrc
sudo ln -s `pwd`/.hgrc $home/.hgrc

sudo unlink $home/.profile
sudo rm $home/.profile
sudo ln -s `pwd`/.profile $home/.profile

sudo unlink $home/.bash_profile
sudo rm $home/.bash_profile
sudo ln -s `pwd`/.bash_profile $home/.bash_profile

sudo unlink $home/.aliases
sudo rm $home/.aliases
sudo ln -s `pwd`/.aliases $home/.aliases

sudo unlink $home/.bashrc
sudo rm $home/.bashrc
sudo ln -s `pwd`/.bashrc $home/.bashrc

sudo unlink $home/.bash_prompt
sudo rm $home/.bash_prompt
sudo ln -s `pwd`/.bash_prompt $home/.bash_prompt