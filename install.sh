#!/bin/bash 

relative_dir=`dirname $0`
dotfiles_dir=`(cd $relative_dir; pwd)`
echo $dotfiles_dir
for file in .bashrc .dir_colors .inputrc .tmux.conf .vimrc .vim
do
  src=$dotfiles_dir/$file
  ln -fs $src $HOME
done
#.bash_prompt
#.vim/
