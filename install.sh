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
base_path=`pwd`/zsh.d
echo "creating symlinks.."

ln -sf $base_path/.zshrc $HOME
ln -sf $base_path/.zshenv $HOME

#
# emacs
#
(
cd emacs.d
./install.sh
)
