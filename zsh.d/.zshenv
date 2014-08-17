# 環境変数を設定するファイル
# ログインシェル/対話シェルで読み込まれる
# スクリプト用シェルでも読み込まれる

export PATH=$HOME/local/bin:$HOME/bin:$PATH

# バージョンチェックし、古いなら新しいものに変える

#echo $ZSH_VERSION | grep 4.3.10
#if [ $? -ne 0 ]; then
#	if [ -e $HOME/bin/zsh ] ; then
#		exec $HOME/bin/zsh
#	fi
#fi

# zshのリポジトリへの変数を用意する スクリプト用
zsh_dir=~/zsh_dotfiles

if [ -d $HOME/local/go/bin ]; then
  export PATH=$PATH:$HOME/local/go/bin
fi
# golang
export GOPATH=$HOME.golang
export PATH=$PATH:$GOPATH/bin
