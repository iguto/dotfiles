############################################################
#  ssh-agentをssh系コマンド実行前に実行
############################################################
## ssh-agent をssh,scp,sftp,rsyncに関連付け
# my-ssh
if [ -e ~/.zshd/run-agent ]; then
  function ssh {
    source ~/.zshd/run-agent
    run-agent
    /usr/bin/ssh $*
  }
  #my-scp
# function scp {
#   source ~/.zshd/run-agent
#   run-agent
#   /usr/local/bin/scp $*
# }
# # my-sftp
# function sftp {
#   source ~/.zshd/run-agent
#   run-agent
#   /usr/local/bin/sftp $*
# }
  # my-rsync
  function my-rsync {
    source ~/.zshd/run-agent
    run-agent
    /usr/bin/rsync $*
  }
  function agent {
    source ~/.zshd/run-agent
    run-agent
  }
  # function screen {
  #   source ~/.zshd/run-agent
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
