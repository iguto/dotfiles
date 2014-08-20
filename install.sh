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
BINSTUB_DIR=.bundle/bin

script_dir=`(cd $(dirname $0); pwd)`/emacs.d
echo $script_dir
bundle install --path .bundle --binstubs=$BINSTUB_DIR
if [ ! -d $HOME/bin ]; then
  mkdir $HOME/bin
fi
for file in `ls $script_dir/$BINSTUB_DIR`
do
  ln -sf $script_dir/$BINSTUB_DIR/$file $HOME/bin
done

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

if [ ! -d $script_dir/inits ]; then
  mkdir $script_dir/inits
fi

ln -s $script_dir $HOME/.emacs.d

# golang
go get -u github.com/nsf/gocode

