#!/bin/bash

#.bash_prompt
for file in .bashrc .dir_colors .inputrc .tmux.conf .vimrc
do
  ln -fs $file $HOME
done
#.vim/
