#!/bin/sh

base_path=`pwd`
echo "creating symlinks.."

ln -sf $base_path/.zshrc $HOME
ln -sf $base_path/.zshenv $HOME

git submodule init
git submodule update
