#!/bin/bash

for path in $(echo $PATH | sed 's/:/ /g')
do
  echo $path
  [ "$path" = "$HOME/bin" ] && home_bin_exists=$path
done
[ ! -d $HOME/bin ] && mkdir $HOME/bin
[ -z $home_bin_exists ] && export PATH=$PATH:$HOME/bin

go_dir=$HOME/.golang
[ ! -d $go_dir ] && mkdir $go_dir
export GOPATH=$go_dir

go get github.com/motemen/ghq
ln -sf $GOPATH/bin/ghq $HOME/bin

go get github.com/peco/peco/cmd/peco
ln -sf $GOPATH/bin/peco $HOME/bin

relative_dir=`dirname $0`
dotfiles_dir=`(cd $relative_dir; pwd)`
echo $dotfiles_dir

for file in .bashrc .dir_colors .inputrc .tmux.conf .vimrc .vim .gitignore .gitconfig
do
  src=$dotfiles_dir/$file
  ln -fs $src $HOME
done

#
# .config
#
[ ! -d ~/.config/peco ] && mkdir -p ~/.config/peco
ln -sf $dotfiles_dir/.config/peco/config.json ~/.config/peco
