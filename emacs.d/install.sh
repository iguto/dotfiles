#!/bin/sh

git clone https://github.com/cask/cask.git ~/.cask
ln -s ~/.cask/bin/cask ~/bin/
(
cd ~/.emacs.d
cask
)

