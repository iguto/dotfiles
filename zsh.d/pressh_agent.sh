function run-agent() {
		/usr/bin/ssh-add -l >& /dev/null
		if [ $? -eq 2 ] ; then
				eval `ssh-agent -s`
		fi
		/usr/bin/ssh-add -l >& /dev/null
		if [ $? -eq 1 ] ; then
	# 公開鍵が ~/.ssh にあると正常に動作しないため、存在しないことを確認
				ls $HOME/.ssh/ | egrep .pub$ > /dev/null
				if [ $? -ne 0 ] ; then
						/usr/bin/ssh-add ~/.ssh/id*
				else
						echo "check ~/.ssh has no publickey." > /dev/stderr
				fi
		fi
}

############################################################
#  ssh-agentをssh系コマンド実行前に実行
############################################################

# 設定のロード
## if [ -x $zsh_dir ] ; then
#echo $zsh_dir > /dev/null
#if [ $? -ne 0 ]; then
#	echo "can't load \$zsh_dir" > /dev/stderr
#fi
#
## ssh-agent をssh,scp,sftp,rsyncに関連付け
# my-ssh
function ssh {
#    source $zsh_dir/run-agent
    run-agent
    /usr/bin/ssh $*
}
  #my-scp
# function scp {
#   source $zsh_dir/run-agent
#   run-agent
#   /usr/local/bin/scp $*
# }
# # my-sftp
# function sftp {
#   source $zsh_dir/run-agent
#   run-agent
#   /usr/local/bin/sftp $*
# }
  # my-rsync
function my-rsync {
#    source $zsh_dir/run-agent
    run-agent
    /usr/bin/rsync $*
}

function agent() {
#		source $zsh_dir/run-agent
    run-agent
}
  # function screen {
  #   source $zsh_dir/run-agent
  #   run-agent
  #   /usr/bin/screen $*
  # }
function vagent {
    ssh-add -l
}


# ssh-agentをkillする
function kill-agent {
		eval `ssh-agent -s -k`
}
