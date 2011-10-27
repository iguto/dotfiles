#!/usr/bin/env zsh

# load my-function. this line depend on ~/.zshenv
source $zsh_dir/my-functions.zsh

# 作成したsftpのバッチファイルを吐き出すディレクトリ
batch_file=$zsh_dir/script_tmp/sftp.batch

# 引数の数が1以下なら、引数不足なので、使い方の表示を行う
if [ $# -le 1 ] ; then
	eecho "bsftp [host:dir send_file]"
	return 
fi

# file name in remote host
rfile=`basename $2`

echo "continue"
# Make sftp batch file
echo "put $2" > $batch_file
echo "chmod 760 $rfile" >> $batch_file

sftp -b $batch_file $1
