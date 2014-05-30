#!/bin/sh

git clone https://github.com/cask/cask.git ~/.cask
if [ ! -d ~/bin ]; then
  echo "directory: ~/bin created."
  mkdir ~/bin
fi
ln -s ~/.cask/bin/cask ~/bin/
(
cd ~/.emacs.d
cask
)

