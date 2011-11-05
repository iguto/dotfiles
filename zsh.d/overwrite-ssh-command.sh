############################################################
#  ssh-agentをssh系コマンド実行前に実行
############################################################

# 設定のロード
echo $zsh_dir > /dev/null
if [ $? -ne 0 ]; then
	echo "can't load \$zsh_dir" > /dev/stderr
fi

## ssh-agent をssh,scp,sftp,rsyncに関連付け
# my-ssh
if [ -e $zsh_dir/run-agent ]; then
  function ssh {
    source $zsh_dir/run-agent
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
    source $zsh_dir/run-agent
    run-agent
    /usr/bin/rsync $*
  }
  function agent {
    source $zsh_dir/run-agent
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

fi

# ssh-agentをkillするコマンドを定義する
function kill-agent {
  eval `ssh-agent -s -k`
}
