#!/bin/sh

base_path=`pwd`
echo "creating symlinks.."

ln -sf $base_path/.zshrc $HOME
ln -sf $base_path/.zshenv $HOME

git submodule init
git submodule update

if [ -d $base_path/zsh-completions ]; then
  rm -rf $base_path/zsh-completions
fi
git clone https://github.com/zsh-users/zsh-completions.git

