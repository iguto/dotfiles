#!/usr/bin/env zsh

# load my-function. this line depend on ~/.zshenv
local func_file=$zsh_dir/my-functions.zsh
if [ -e $func_file ] ; then
	source $func_file
else
	echo "ERROE: can't load $func_file"
	return 1
fi

# 作成したsftpのバッチファイルを吐き出すディレクトリ
#batch_dir=$zsh_dir/script_tmp
local batch_dir=/tmp/batchdir
if [ ! -d $batch_dir ] ; then
	mkdir -p $batch_dir
fi
local bfile_name=sftp.batch
local bfile=$batch_file/$bfile_name

return 0

# 引数の数が1以下なら、引数不足なので、使い方の表示を行う
if [ $# -le 1 ] ; then
	echo "`basename $0` [host:dir send_file]" > /dev/stderr
	return 
fi

# file name in remote host
local rfile=`basename $2`

# Make sftp batch file
echo "put $2" > $bfile
echo "chmod 760 $rfile" >> $bfile

#sftp -b $batch_file $1
