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

## zsh設定リポジトリへのパス
zsh_dir=$HOME/zsh_dotfiles

############################################################
#  ターミナル起動時に実行するコマンド
############################################################

## いる場所で、ssh_configを切り替える
local netset=$zsh_dir/ch-network-setting.rb
if [ -e $netset ] ; then
	/usr/local/bin/ruby $netset
fi

############################################################
## history/ヒストリサーチ
############################################################
setopt APPEND_HISTORY
# for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# history file save this directory/file
export HISTFILE=${HOME}/.zsh_history
# number of command that keep on memory
export HISTSIZE=100000
# HISTFILEに保存するコマンド数 HISTSIZEより小さいとあまり意味がない?
export SAVEHIST=100000
# 重複があれば、古いほうを削除
#setopt hist_ignore_all_dups
# 余分な空白があれば削除して履歴へ
setopt hist_reduce_blanks
# コマンドラインの先頭にくうはくがあれば、ヒストリに追加しない
setopt hist_ignore_space


############################################################
#  history-grep 候補を一覧表示するヒストリ検索
############################################################
local histgrep=$zsh_dir/history-grep.zsh
if [ -r $histgrep ]; then
		source $histgrep
fi

##########################################################
# プロンプト
##########################################################

## 仮想ターミナルならシンプルな、そうでなければラインな
## プロンプト設定読み込み

local simple_prompt=$zsh_dir/.zsh_prompt
if [ -e $simple_prompt ] ; then
	source $simple_prompt
fi

if [ "$TERM" != linux ] ; then
	local ip_prompt=$zsh_dir/ip_prompt_cus.zsh
	if [ -e $ip_prompt ] ; then
		source $ip_prompt
	fi
fi

############################################################
# gitのブランチ情報を右プロンプトに表示
############################################################
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "+"
	zstyle ':vcs_info:git:*' unstagedstr "-"
	zstyle ':vcs_info:git:*' formats '[%b[%c%u]]'
	zstyle ':vcs_info:git:*' actionformats '[%b|%a[%c%u]]'
fi

function _update_vcs_info_msg() {
	psvar=()
	LANG=en_US.UTF-8 vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)" # [%20<..<%~]"

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
setopt COMPLETE_IN_WORD

## 補完スタイル
#zstyle ':completion:*' completer _expand _complete _approximate #_match
zstyle ':completion:*' completer _oldlist _complete  _expand
## 2011.05.25 auto-fuのために_oldlistを先頭に追加した。

## ↑ の_matchについて、一意に対象を絞るため、補完位置ずらしていく
zstyle 'completion::match:*' insert-unambiguous true

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
alias ld='ls -d *(/)'

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

## グローバルエイリアス
alias -g G="| grep --color='always'"
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
 
############################################################
# zawを読み込む (全く使ってない)
############################################################
if [ -e  $zsh_dir/zaw/zaw.zsh ] ; then
	source $zsh_dir/zaw/zaw.zsh
fi



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
# 毎回スクリーンを立ち上げる設定
############################################################

#which screen > /dev/null
#if [ $? -eq 0 ] && [ $SHLVL = 1 ] ; then
#    screen -qR
#fi
#

############################################################
# URLを自動でクオート処理
############################################################
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


### misc
# memo
# M-? で which
#
setopt auto_name_dirs  # !!!
alias ndate='date +%m%d_%H:%M:%S'


## smart insert word
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
  '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
#bindkey '^]' insert-last-word
bindkey '.' insert-last-word

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
#
#
#
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
