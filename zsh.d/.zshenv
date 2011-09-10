# 環境変数を設定するファイル
# ログインシェル/対話シェルで読み込まれる
# スクリプト用シェルでは読み込まれないため注意

#export PATH=$HOME/bin:$PATH

# バージョンチェックし、古いなら新しいものに変える

echo $ZSH_VERSION | grep 4.3.10
if [ $? -ne 0 ]; then
	exec $HOME/bin/zsh
fi
