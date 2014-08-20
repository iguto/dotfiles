#!/bin/bash 

relative_dir=`dirname $0`
dotfiles_dir=`(cd $relative_dir; pwd)`
echo $dotfiles_dir
for file in .bashrc .dir_colors .inputrc .tmux.conf .vimrc .vim .gitignore .gitconfig
do
  src=$dotfiles_dir/$file
  ln -fs $src $HOME
done

#
# zsh 
#
(
cd zsh.d
./install.sh
)


#
# emacs
#
(
cd emacs.d
./install.sh
)
