############################################################
#  環境変数/シェル変数
############################################################
## 文字コードを設定
export LANG=ja_JP.UTF-8

## 相対パスでcdする際、カレントディレクトリに指定したディレクトリが
## 存在しない場合、この変数で指定したディレクトリを探索してみる
#cdpath=$HOME

## ページャをlessと明示
export PAGER=less
export SUDO_EDITOR="vim -u $HOME/.vimrc"
export EDITOR=vim  # pit用の設定
export GISTY_DIR="$HOME/dev/gists"
## zsh設定リポジトリへのパス
zsh_dir=$HOME/zsh_dotfiles

# showterm privateserver
export SHOWTERM_SERVER='http://133.92.145.188/showterm'

# TERM
export TERM="xterm-256color"

#
# C-sをsttyから解放
#
stty stop undef

############################################################
## history/ヒストリサーチ
############################################################
# history file save this directory/file
export HISTFILE=${HOME}/.zsh_history
# number of command that keep on memory
export HISTSIZE=100000
# HISTFILEに保存するコマンド数 HISTSIZEより小さいとあまり意味がない?
export SAVEHIST=100000

setopt APPEND_HISTORY
# for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# 重複があれば、古いほうを削除
setopt hist_ignore_all_dups
# 余分な空白があれば削除して履歴へ
setopt hist_reduce_blanks
# コマンドラインの先頭にくうはくがあれば、ヒストリに追加しない
setopt hist_ignore_space
# 時刻の記録
setopt extended_history

############################################################
#  ディレクトリスタック
############################################################
# http://journal.mycom.co.jp/column/zsh/006/index.html より
# "cd"の入力なしで、カレントディレクトリを変更できる
#setopt auto_cd 
# 移動したディレクトリを自動で記憶
setopt auto_pushd
# ディレクトリスタック内に重複があれば、古いほうを削除
setopt pushd_ignore_dups

############################################################
# グロブパターン
############################################################
## ファイルグロブで #, ~, ^ を正規表現として扱う
setopt extended_glob
############################################################
#  ファイル名生成機能
############################################################
# {a-c}を展開する
setopt brace_ccl

############################################################
#  単語の区切 M-BS M-d で削除する単語の単位
############################################################
# /usr/local/bin で M-BS すると /usr/local/bin
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

############################################################
# フロー制御
############################################################
# C-s/C-qでフロー制御をしない
setopt no_flow_control

############################################################
#  コマンドラインコメント
############################################################
## コマンドラインで '#'以降をコメント扱い
setopt interactive_comments

## 改行がなくても出力する
unsetopt promptcr

##########################################################
# プロンプト
##########################################################
## 仮想ターミナルならシンプルな、そうでなければラインな
## プロンプト設定読み込み
if [ "$TERM" = linux ] ; then
	local simple_prompt=$zsh_dir/.zsh_prompt
	if [ -e $simple_prompt ] ; then
		source $simple_prompt
	fi
else
	
	# IPアドレス表示プロンプト
	local ip_prompt=$zsh_dir/ip_prompt_cus.zsh
	if [ -e $ip_prompt ] ; then
		source $ip_prompt
	fi
fi

############################################################
# gitのブランチ情報を右プロンプトに表示
############################################################
# vcs_info 設定
RPROMPT=""

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


if is-at-least 4.3.10; then
    # git 用のフォーマット
    # git のときはステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
    zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then
    # git のときはフック関数を設定する

    # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    # のメッセージを設定する直前のフック関数
    # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
    # 各関数が最大3回呼び出される。
    zstyle ':vcs_info:git+set-message:*' hooks \
                                            git-hook-begin \
                                            git-untracked \
                                            git-push-status \
                                            git-nomerge-branch \
                                            git-stash-count

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
            # 0以外を返すとそれ以降のフック関数は呼び出されない
            return 1
        fi

        return 0
    }

    # untracked フィアル表示
    #
    # untracked ファイル(バージョン管理されていないファイル)がある場合は
    # unstaged (%u) に ? を表示
    function +vi-git-untracked() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if command git status --porcelain 2> /dev/null \
            | awk '{print $1}' \
            | command grep -F '??' > /dev/null 2>&1 ; then

            # unstaged (%u) に追加
            hook_com[unstaged]+='?'
        fi
    }

    # push していないコミットの件数表示
    #
    # リモートリポジトリに push していないコミットの件数を
    # pN という形式で misc (%m) に表示する
    function +vi-git-push-status() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" != "master" ]]; then
            # master ブランチでない場合は何もしない
            return 0
        fi

        # push していないコミット数を取得する
        local ahead
        ahead=$(command git rev-list origin/master..master 2>/dev/null \
            | wc -l \
            | tr -d ' ')

        if [[ "$ahead" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+="(p${ahead})"
        fi
    }

    # マージしていない件数表示
    #
    # master 以外のブランチにいる場合に、
    # 現在のブランチ上でまだ master にマージしていないコミットの件数を
    # (mN) という形式で misc (%m) に表示
    function +vi-git-nomerge-branch() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" == "master" ]]; then
            # master ブランチの場合は何もしない
            return 0
        fi

        local nomerged
        nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

        if [[ "$nomerged" -gt 0 ]] ; then
            # misc (%m) に追加
            hook_com[misc]+="(m${nomerged})"
        fi
    }


    # stash 件数表示
    #
    # stash している場合は :SN という形式で misc (%m) に表示
    function +vi-git-stash-count() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local stash
        stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
        if [[ "${stash}" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+=":S${stash}"
        fi
    }
fi

function _update_vcs_info_msg() {
    local -a messages
    local prompt

    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # vcs_info で何も取得していない場合はプロンプトを表示しない
        prompt=""
    else
        # vcs_info で情報を取得した場合
        # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
        # それぞれ緑、黄色、赤で表示する
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        # 間にスペースを入れて連結する
        prompt="${(j: :)messages}"
    fi

    RPROMPT="$prompt"
}
add-zsh-hook precmd _update_vcs_info_msg

############################################################
#   補完/補完スタイル
############################################################

## 補完機能上位版を使用
autoload -U compinit
compinit

## 補完候補を詰め込んで表示(なるべく1画面に収める)
setopt list_packed

## ファイル名のカラー表示
if [ -e ~/.dir_colors ]; then
	eval `dircolors -b ~/.dir_colors`
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}	

## a-zとA-Zを相互置換、'-','_','.'があるところで*を補ったような補完を実現
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'

#allow tab completion in the middle of a word
#setopt COMPLETE_IN_WORD

## 補完スタイル
#zstyle ':completion:*' completer _expand _complete _approximate #_match
zstyle ':completion:*' completer _oldlist _complete  _expand
## 2011.05.25 auto-fuのために_oldlistを先頭に追加した。

## ↑ の_matchについて、一意に対象を絞るため、補完位置ずらしていく
#zstyle 'completion::match:*' insert-unambiguous true

## 保管ができるコマンドを追加する  https://github.com/zsh-users/zsh-completions
fpath=($zsh_dir/zsh_completions/src $fpath)

############################################################
# 補完候補表示の際、グループ名表示し、グループごとに表示する
############################################################
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
## グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
## したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

############################################################
#  ssh-agentをssh系コマンド実行前に実行
############################################################
## ssh-agent をssh,scp,sftp,rsyncに関連付け
local overssh=$zsh_dir/pressh_agent.sh
if [ -e $overssh ] ; then
	source $overssh
fi

############################################################
# emacs起動のモード？をremote/localで切り替える
############################################################
local sw_emacs=$zsh_dir/switch-emacs.sh
if [ -e $sw_emacs ] ; then
	source $sw_emacs
fi
alias emacs=switch_emacs
############################################################
# bindkeyの変更
############################################################
bindkey -e
# 途中まで打った後、C-pで打った文字でヒストリサーチする(C-nも)
bindkey '' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '' history-beginning-search-forward  # 同上
# バージョン判定して、C-rの上位版を有効にする
# 参考: http://subtech.g.hatena.ne.jp/mayuki/20110310/1299761759
autoload -Uz is-at-least
if is-at-least 4.3.10; then
	bindkey '' history-incremental-pattern-search-backward
	#bindkey 'S history-incremental-pattern-serach-forward
	# ↑ ^Sが入力できないので使えていない
fi

# 消えてしまっているウィジェットの再設定
bindkey 'm' _most_recent_file
bindkey '' _read_comp
bindkey 'C' _correct_filename
bindkey 'c' _correct_word
############################################################
#  alias
############################################################
## 色表示関連
# less 色表示を残す? もとの表示を維持しようとする
alias grep="grep --color='always'"
alias less='less -R'
#色つき、データサイズ単位付きで、
# ファイル名の数値は、　1, 2 01.1 などではなく、1, 01.1, 2　のようにバージョン管理しやすい順で表示する
## Alias for ls
alias ls="ls --color=always -hvF" 
alias l='ls'
alias ll='ls -lF' la='ls -aF' laa='la | grep ^\.' lla='la -l'
alias lsd='ls -d *(/)'

## ディレクトリ移動関連
alias cd..='cd ..'
alias -g ...='../..'
alias -g ....='../../..'

## 実行確認
# -i : 上書き確認, 
# -u : 移動元の更新日時が更新先より古いか、同じ場合は上書きしない
# -b : 上書き必要がある場合、バックアップファイルを作成する
# -S SUFFIX : SUFFIXをバックアップファイルに付け加える文字列とする
alias mv='mv -ibS .mvbak'
alias cp='cp -ibS .cpbak'

# bell
alias bell='echo -e "\a"'

## グローバルエイリアス
alias -g G="| grep --color='always'"
#bindkey -s G '| grep'
alias -g H='| head'
alias -g L='| less'
alias -g T='| tail'
alias -g W='| wc -l'
alias -g N='/dev/null'

# 受け取ったストリームをクリップボードへ
# デフォルトで入っていないので、有無の確認が必要
alias -g X='| xsel --clipboard --input'

# tarコマンドが拡張子を自動認識し、展開してくれるようなのでalias設定
# tar.gz tar.gz2 
# zipはこれでは使えない、unzipを使う。
alias tare='tar xvf'

## この設定ファイル編集を簡略化
alias zrc='vim ~/.zshrc'

## emacs
alias enw="emacs -nw"
alias e="emacs"

# nautilus(ファイルブラウザ) カレントディレクトリを開く
alias nndisp="nautilus . &"

# rspec color
alias rspec='rspec -c'

# Read only vim
alias vimr='vim -R'

# git alias
alias gs='git status -s'
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gdd='git diff --cached'

function p_decode() {
  sed 's/=/:**:/g' | tr % = | nkf -emQ | sed 's/\:\*\*\:/=/g'
}
alias pdec=p_decode

function httprequest() {
  cut -d' ' -f 6-7 | sed 's/^\"//'
}

function sql_filter() {
  \grep '?' | egrep 'SELECT|WHERE|INSERT|JOIN|FROM|%20OR%20'
}

############################################################
# zawを読み込む (全く使ってない)
############################################################
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook

local zaw_file=$zsh_dir/site_script/zaw/zaw.zsh
if [ -e  $zaw_file ] ; then
	source $zaw_file
fi

#zaw-register-src -n ack $zsh_dir/site_script/zaw/sources/ack.zsh
zaw-register-src -n cdr $zsh_dir/site_script/zaw/sources/cdr.zsh

# key-bind
bindkey '' zaw-history
bindkey '' zaw-tmux

#opt
zstyle ':filter-select:highlight' selected fg=black,bg=white
zstyle ':filter-select:highlight' matched fg=yellow,red
zstyle ':filter-select' max-lines 10 # use 10 lines for filter-select
zstyle ':filter-select' max-lines -10 # use $LINES - 10 for filter-select
zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
zstyle ':filter-select' extended-search yes # see below

############################################################
# zsh_command_not_found  存在しないコマンドを実行→ 近いパッケージを表示
############################################################
local cmd_nfound=/etc/zsh_command_not_found
if [ -e $cmd_nfound ] ; then
	source $cmd_nfound
fi

#####################################################################
# 256色表示確認                                                     #
#####################################################################
function pcolor() {
	for ((f = 0; f < 255; f++)); do
		printf "\e[38;5;%dm %3d*■\e[m" $f $f
		if [[ $f%8 -eq 7 ]] then
			printf "\n"
		fi
	done
echo
}

#####################################################################
# tmux ログアウト → アタッチしてもssh-agent forwardが使えるように
#####################################################################
SOCK="/tmp/ssh-agent-$USER"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
  rm -f $SOCK
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi


function _chdir_parent_dir() {
  builtin cd ..
  zle accept-line
}
zle -N _chdir_parent_dir
bindkey '^W' _chdir_parent_dir

##
# k
###
k=$zsh_dir/site_script/k/k.sh
if [ -e $k ]; then
  source $k
  alias ll=k
fi
############################################################
# auto-fu インクリメンタルに補完候補を表示
############################################################
#autofu=$zsh_dir/auto-fu.zsh
#if [ -e $autofu ] ; then
#	source $autofu
#	zle-line-init () {
#		auto-fu-init;
#	}
#	zle -N zle-line-init
#	zstyle ':auto-fu:var' disable magic-space
#	##	unsetopt autoremoveslash
#fi

############################################################
# サークルのサーバへのssh接続を楽にする
#   IPアドレスの4オクテット目の入力だけで接続可能
#   ただし、ユーザ名の指定は l オプションで
############################################################
sshl=$zsh_dir/ssh-labo.sh
if [ -e $sshl ] ; then
	source $sshl
fi

############################################################
#  history-grep 候補を一覧表示するヒストリ検索
############################################################
local histgrep="$zsh_dir/history-grep.zsh"
if [ -r $histgrep ]; then
		source $histgrep
fi

############################################################
#  絶対パスへ展開してヒストリ登録するcd
############################################################
zcd_file=$zsh_dir/zcd.zsh
if [ -e $zcd_file ]; then
		source $zcd_file
fi
alias cd='zcd'

# 256色表示を個別にテストするための関数
function color_test {
	if [ $# -lt 2 ]; then
		echo "color_test message number"
	else
		echo "\033[38;05;${2}m${1}\033[0m"
	fi
}

# alias diff mode
which colordiff > /dev/null
if [ $? -eq 0 ]; then
  alias diff='colordiff'
fi
alias diff='diff -u'

############################################################
# URLを自動でクオート処理
############################################################
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

### misc
# memo
# M-? で which
#
#setopt auto_name_dirs  # !!!
alias ndate='date +%m%d_%H:%M:%S'

## smart insert word
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
  '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
#bindkey '^]' insert-last-word
#bindkey '.' insert-last-word

############################################################
# percolを使ったヒストリ検索
############################################################
function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac=gtac || tac=tac
        BUFFER=$($tac $HISTFILE | sed 's/^: [0-9]*:[0-9]*;//' | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^]' percol_select_history
fi


## emacsclient をシームレスに使うための関数
## http://k-ui.jp/?p=243
function e(){
    echo "[$0] emacsclient -c -t $*";
    (emacsclient -c -t $* ||
        (echo "[$0] emacs --daemon"; emacs --daemon &&
            (echo "[$0] emacsclient -c -t $*"; emacsclient -c -t $*)) ||
        (echo "[$0] emacs $*"; emacs $*))
}

# ソケットの場所を環境変数に覚えてもらう
# emacs のバージョンによって少し場所が違うようなので、
# *** "/tmp" を要確認 ***
export USER_ID=`id -u`
export EMACS_TMP_DIR="/tmp/emacs$USER_ID"
export EMACS_SOCK="$EMACS_TMP_DIR/server"

## screen emacsclient をシームレスに使うための関数
function se(){
    if which emacsclient &&
        (echo "[$0] ls $EMACS_SOCK "; ls $EMACS_SOCK) ||
        (echo "[$0] emacs --daemon"; emacs --daemon)
    then
        echo "[$0] screen -t emacs emacsclient -t -c $*";
        screen -t emacs emacsclient -t -c $*
    elif which emacs
    then
        echo "[$0] screen emacs -t -c $*";
        screen emacs -t -c $*
    fi

}

##  $EMACS_TMP_DIR が無いとき
if ! [ -d $EMACS_TMP_DIR ]; then

   #（socket 使わないバージョン、毎回emacs--daemonしてる。。。）
    function se(){
        if which emacsclient
        then
            echo "[$0] emacs --daemon"
            emacs --daemon
            echo "[$0] screen -t emacs emacsclient -t -c $*"
            screen -t emacs emacsclient -t -c $*
        elif which emacs
        then
            echo "[$0] screen emacs -t -c $*";
            screen emacs -t -c $*
        fi
    }
fi
#------------------------------------------------------------
alias irb=pry

######################################################################
# 最近のディレクトリへ移動
######################################################################
#autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#add-zsh-hook chpwd chpwd_recent_dirs
#zstyle ':chpwd:*' recent-dirs-max 5000
#zstyle ':chpwd:*' recent-dirs-default yes
#zstyle ':completion:*' recent-dirs-insert both


######################################################################
# autojump
#pp#####################################################################
autojump_path=/etc/profile.d/autojump.zsh
if [ -e $autojump_path ]; then
  source $autojump_path
fi

## z
#_Z_CMD=j
#source $zsh_dir/site_script/z/z.sh
#precmd() {
#	_z --add "$(pwd -P)"
#}
#
######################################################################
# tmux
######################################################################
#
# tmuxinator
#
tmuxinator_path=$HOME/.tmuxinator/scripts/tmuxinator 
if [ -s $tmuxinator_path ]; then
  source $tmuxinator_path
fi

# tmux ログアウト → アタッチしてもssh-agent forwardが使えるように
#
SOCK="/tmp/ssh-agent-$USER"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
  rm -f $SOCK
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# memo
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#- pastebinit
#		webサービスpastebinのクライアント
#		パイプ等の形で、出力を渡してやると、その出力をWebへ投稿する
#		投稿したページのURLを代わりに出力するので、
#		それを他の人に知らせるなどする
#		オプションでシンタックスハイライトの指定もできる様子
#
#- vim -R 
#		コマンドのview相当。読み込み専用で開くことができる
#
#- vim - 
#		ファイルの内容をvimで開くのではなく、標準出力ノ内容をvimでひらく
#
#- percol
#		開いたファイルの内容を検索しつつ表示でくきるページャ
#
#- 整形 fmt
#
#- lzma
#		7-zip形式の圧縮・展開ツール
#- netコマンド
#		sambaツール？
#- whiptail, dialog(dialogは要インストール)
#		CUIインストール時のようなパネルを作成するツール？
#		シェルスクリプト向け
#- rlwrap
#		ヒストリ機能のない対話環境を引数にすることで、実行可能
#		ヒストリ機能を強制的につけるようなもの？
# $ mono NetWorkMiner.exe "in opt"

function _chdir_parent_dir() {
  builtin cd ..
  zle accept-line
}
zle -N _chdir_parent_dir
bindkey '^W' _chdir_parent_dir

#
# direnv
#
which direnv > /dev/null && eval "$(direnv hook zsh)"


##
# k
###
k=$zsh_dir/site_script/k/k.sh
if [ -e $k ]; then
  source $k
  alias ll=k
fi

###
# tagdir
###
tagdir_script=$zsh_dir/site_script/tagdir/tagdir.zsh
[ -e $tagdir_script ] && source $tagdir_script

# added by travis gem
[ -f /home/usr/member/ookawa/.travis/travis.sh ] && source /home/usr/member/ookawa/.travis/travis.sh
source ~/.fzf.zsh
