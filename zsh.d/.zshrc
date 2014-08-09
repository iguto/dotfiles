#===========================================================
#  環境変数/シェル変数
#===========================================================
export LANG=ja_JP.UTF-8
export TERM="xterm-256color"
export PAGER=less
export EDITOR=vim
export SUDO_EDITOR="vim -u $HOME/.vimrc"
export GISTY_DIR="$HOME/dev/gists"

## zsh設定リポジトリへのパス
real_path=`readlink -f $HOME/.zshrc`
zsh_dir=`(cd $(dirname $real_path); pwd)`

#
# C-sをsttyから解放
#
stty stop undef

#===========================================================
## history/ヒストリサーチ
#===========================================================
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extended_history

#===========================================================
# オプション 
#===========================================================
setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob  # ファイルグロブで #, ~, ^ を正規表現として扱う
setopt brace_ccl # {a-c}を展開する ファイル名生成
setopt no_flow_control # C-s/C-qでフロー制御をしない
setopt interactive_comments # コマンドラインで '#'以降をコメント扱い
unsetopt promptcr # 改行がなくても出力する
setopt list_packed # 補完候補を詰め込んで表示(なるべく1画面に収める)

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # 単語区切りの設定
[ -e ~/.dir_colors ] && eval `dircolors -b ~/.dir_colors` # ファイル名のカラー表示

#=========================================================
# プロンプト
#=========================================================
local simple_prompt=$zsh_dir/zsh_simple_prompt
local ip_prompt=$zsh_dir/ip_prompt_cus.zsh

if [ "$TERM" = linux ] ; then
  [ -e $simple_prompt ] && source $simple_prompt
else
  [ -e $ip_prompt ] && source $ip_prompt
fi

#===========================================================
#   補完/補完スタイル
#===========================================================
## 補完機能上位版を使用
autoload -U compinit && compinit

zstyle ':completion:*' completer _oldlist _complete  _expand
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}	
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**' # a-zとA-Zを相互置換、'-','_','.'があるところで*を補ったような補完を実現
fpath=($zsh_dir/zsh_completions/src $fpath) # 保管ができるコマンドを追加する  https://github.com/zsh-users/zsh-completions

# 補完候補表示の際、グループ名表示し、グループごとに表示する
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' group-name ''

#===========================================================
# bindkeyの変更
#===========================================================
bindkey -e
# 途中まで打った後、C-pで打った文字でヒストリサーチする(C-nも)
bindkey '' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '' history-beginning-search-forward  # 同上

# 消えてしまっているウィジェットの再設定
bindkey 'm' _most_recent_file
bindkey '' _read_comp
bindkey 'C' _correct_filename
bindkey 'c' _correct_word
#===========================================================
# gitのブランチ情報を右プロンプトに表示
#===========================================================
local vcs_rprompt=$zsh_dir/vcs_rprompt.zsh
[ -e $vcs_rprompt ] && source $vcs_rprompt

#===========================================================
#  alias
#===========================================================
local alias_file=$zsh_dir/alias.zsh
[ -e $alias_file ] && source $alias_file
#===========================================================
#  ssh-agentをssh系コマンド実行前に実行
#===========================================================
## ssh-agent をssh,scp,sftp,rsyncに関連付け
local overssh=$zsh_dir/pressh_agent.sh
[ -e $overssh ] && source $overssh

#===========================================================
# zawを読み込む 
#===========================================================
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
local zaw_file=$zsh_dir/site_script/zaw/zaw.zsh
[ -e  $zaw_file ] && source $zaw_file
zaw-register-src -n cdr $zsh_dir/site_script/zaw/sources/cdr.zsh
zstyle ':filter-select:highlight' selected fg=black,bg=white
zstyle ':filter-select:highlight' matched fg=yellow,red
zstyle ':filter-select' max-lines 10 # use 10 lines for filter-select
zstyle ':filter-select' max-lines -10 # use $LINES - 10 for filter-select
zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
zstyle ':filter-select' extended-search yes # see below

bindkey '' zaw-history
bindkey '' zaw-tmux
#===========================================================
# zsh_command_not_found  存在しないコマンドを実行 -> 近いパッケージを表示
#===========================================================
local cmd_nfound=/etc/zsh_command_not_found
[ -e $cmd_nfound ] && source $cmd_nfound

#====================================================================
# 256色表示確認                                                     #
#====================================================================
function pcolor() {
  for ((f = 0; f < 255; f++))
  do
    printf "\e[38;5;%dm %3d*■\e[m" $f $f
    [[ $f%8 -eq 7 ]] && printf "\n"
  done
  echo
}

#====================================================================
# widget
#====================================================================
function _chdir_parent_dir() {
  builtin cd ..
  zle accept-line
}
zle -N _chdir_parent_dir
bindkey '^W' _chdir_parent_dir

local k=$zsh_dir/site_script/k/k.sh
if [ -e $k ]; then
  source $k
  alias ll=k
fi

#===========================================================
# サークルのサーバへのssh接続を楽にする
#   IPアドレスの4オクテット目の入力だけで接続可能
#   ただし、ユーザ名の指定は l オプションで
#===========================================================
local sshl=$zsh_dir/ssh-labo.sh
if [ -e $sshl ] ; then
	source $sshl
fi

#===========================================================
#  history-grep 候補を一覧表示するヒストリ検索
#===========================================================
local histgrep="$zsh_dir/history-grep.zsh"
[ -r $histgrep ] && source $histgrep

#===========================================================
#  絶対パスへ展開してヒストリ登録するcd
#===========================================================
local zcd_file=$zsh_dir/zcd.zsh
[ -e $zcd_file ] && source $zcd_file
alias cd='zcd'

#===========================================================
# URLを自動でクオート処理
#===========================================================
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

## smart insert word
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
  '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'

#=====================================================================
# autojump
#=======================================================================
autojump_path=/etc/profile.d/autojump.zsh
[ -e $autojump_path ] && source $autojump_path
#=====================================================================
# tmux
#=====================================================================
# tmux ログアウト -> アタッチしてもssh-agent forwardが使えるように
#
SOCK="/tmp/ssh-agent-$USER"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]; then
  rm -f $SOCK
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi

#
# direnv
#
which direnv > /dev/null && eval "$(direnv hook zsh)"

#
# tagdir
#
tagdir_script=$zsh_dir/site_script/tagdir/tagdir.zsh
[ -e $tagdir_script ] && source $tagdir_script

# 
fpath=($fpath /home/ookawa/.ghq/github.com/iguto/zsh_dotfiles/site_script/zaw/functions)

# added by travis gem
[ -f /home/usr/member/ookawa/.travis/travis.sh ] && source /home/usr/member/ookawa/.travis/travis.sh
source ~/.fzf.zsh

#
# github cloned repository list widget.
#
function repository-list () {
  which ghq peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install ghq and peco" > /dev/stderr
    return 1
  fi
  local selected_dir=$(ghq list -p | peco)
  BUFFER="cd $selected_dir"
  zle accept-line
  #zle clear-screen
}
zle -N repository-list
bindkey "r" repository-list


function list-directories() {
  which ghq peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install ghq and peco" > /dev/stderr
    return 1
  fi
  directories=$(find -type d -maxdepth 1 -mindepth 1 | sed 's/\.\///' | sort)
  if [ -z $directories ]; then
    echo "directory does not exist."
    return 2
  fi
  directory=$(echo $directories | peco)
  [ $? -eq 1 ] && return 0
  BUFFER="cd $directory"
  cd $directory
  zle accept-line
  list-directories
}
zle -N list-directories
bindkey "d" list-directories

