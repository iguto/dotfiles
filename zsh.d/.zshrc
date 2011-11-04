############################################################
#  環境変数/シェル変数
############################################################
#文字コードを設定
export LANG=ja_JP.UTF-8

# 相対パスでcdする際、カレントディレクトリに指定したディレクトリが
# 存在しない場合、この変数で指定したディレクトリを探索してみる
cdpath=$HOME

# ページャをlessと明示
export PAGER=less

# zsh関連の別ファイルを置く場所へのパス
zsh_dir=$HOME/zsh_dotfiles

############################################################
#  ターミナル起動時に実行するコマンド
############################################################
# カレントディレクトリの変更
#cd $HOME

# いる場所を自動で判断し、ssh_configを切り替える
local netset=$zsh_dir/ch-network-setting.rb
if [ -e $netset ] ; then
	/usr/local/bin/ruby $netset
fi
############################################################
## history
############################################################
setopt APPEND_HISTORY
# for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# history file save this directory/file
export HISTFILE=${HOME}/.zsh_history
# number of command that keep on memory
export HISTSIZE=10000
# HISTFILEに保存するコマンド数 HISTSIZEより小さいとあまり意味がない?
export SAVEHIST=10000
# 重複があれば、古いほうを削除
setopt hist_ignore_all_dups
# 余分な空白があれば削除して履歴へ
setopt hist_reduce_blanks

setopt hist_ignore_space

##########################################################
###  別ファイルの読み込み
#         主にプロンプト
##########################################################

#====== 仮想ターミナルならシンプルな、そうでなければラインな
#       プロンプトを読み込む
# プロンプト設定読み込み
#

local simple_prompt=$zsh_dir/.zsh_prompt
if [ -e $simple_prompt ] ; then
	source $simple_prompt
fi

# 自作? ラインプロンプトを使用する
if [ "$TERM" != linux ] ; then
	local line_prompt=$zsh_dir/.zsh_line
	if [ -e $line_prompt ] ; then
		source $line_prompt
	fi
	local ip_prompt=$zsh_dir/ip_prompt.zsh
	if [ -e $ip_prompt ] ; then
		source $ip_prompt
	fi
fi

if [ "$TERM" = screen ] ; then
	local screen_prompt=$zsh_dir/.zsh_prompt4screen
	if [ -e $screen_prompt ] ; then
		source $screen_prompt
	fi
fi


############################################################
#   補完候補
############################################################
# 補完機能は上位版を使用
autoload -U compinit
compinit

# 補完候補を詰め込んで表示(なるべく1画面に収めるため)
setopt list_packed

## ファイル名のカラー表示
#export `dircolors -b`
if [ -e ~/.dir_colors ]; then
	eval `dircolors -b ~/.dir_colors`
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}	

## a-zとA-Zを相互置換、'-','_','.'があるところで*を補ったような補完を実現
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
## ↑ と同じ効果???
#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# 補完スタイル
#zstyle ':completion:*' completer _expand _complete _approximate #_match
zstyle ':completion:*' completer _oldlist _complete  _expand _match 
# 2011.05.25 auto-fuのために_oldlistを先頭に追加した。
# ↑ の_matchについて、一意に対象を絞るため、補完位置ずらしていく
zstyle 'completion::match:*' insert-unambiguous true

############################################################
#  ssh-agentをssh系コマンド実行前に実行
############################################################
## ssh-agent をssh,scp,sftp,rsyncに関連付け
local overssh=$zsh_dir/overwrite-ssh-command.sh
if [ -e $overssh ] ; then
	source $overssh
fi

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
fi

############################################################
#  alias
############################################################
## 色表示関連
#色つき、データサイズ単位付きで、
# ファイル名の数値は、　1, 2 01.1 などではなく、1, 01.1, 2　のようにバージョン管理しやすい順で表示する
# less 色表示を残す? もとの表示を維持しようとする
alias grep="grep --color='always'"
alias less='less -R'
alias ls="ls --color=always -hvF" 
## Alias for ls
alias l='ls'
alias ll='ls -lF' la='ls -aF' laa='la | grep ^\.' lla='la -l'

## ディレクトリ移動関連
alias cd..='cd ..'
alias cd...='../..'
alias cd ...='../..'
alias cd....='../../..' 
alias cd ....='../../..' 

## 実行確認
# -i 上書き確認
alias cp='cp -i'
# -i : 上書き確認, 
# -u : 移動元の更新日時が更新先より古いか、同じ場合は上書きしない
# -b : 上書き必要がある場合、バックアップファイルを作成する
# -S SUFFIX : SUFFIXをバックアップファイルに付け加える文字列とする
alias mv='mv -ibS .mvbak'

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
# ログファイル参照用
alias tailf='tail -f'

# rsync 常用するものをセット
alias rsync='rsync -av -e ssh'

# tarコマンドが拡張子を自動認識し、展開してくれるようなのでalias設定
# tar.gz tar.gz2 
# zipはダメなようなので、unzipを使う。
alias tare='tar xvf'

## この設定ファイル編集を簡略化
alias zrc='vim ~/.zshrc'

alias sshp='ssh -o PreferredAuthentications=password'

## emacs
# タイプミス用
alias eamcs='emacs'
alias enw="emacs -nw"
alias e="emacs"

# 相対パスを絶対パスに変換してヒストリ登録するcd
alias cd='zcd'

# nautilus カレントディレクトリを開く
alias nndisp="nautilus . &"
############################################################
#  ディレクトリスタック利用
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
#  history-grep 候補を一覧表示するヒストリ検索
############################################################
HISTORY_MENU_LENGTH=20
typeset -A HISTORY_MENU_KEYS
set -A HISTORY_MENU_KEYS a 1 s 2 d 3 f 4 g 5 h 6 j 7 k 8 l 9 q 10 \
                w 11 e 12 r 13 t 14 y 15 u 16 i 17 o 18 p 19 @ 20
autoload -U read-from-minibuffer
HISTORY_GREP_TEMPFILE=/tmp/hmgrep.tmp
history-grep-menu () {
	read-from-minibuffer "history grep: "
	if [ -n "$REPLY" ]; then
		 history -n 1 | egrep "$REPLY" | tail -100 | uniq | tail -$HISTORY_MENU_LENGTH | tac > $HISTORY_GREP_TEMPFILE
			zle -M  "`ruby -e '%w[a s d f g h j k l q w e r t y u i o p @].zip(ARGF.readlines){|k,l| print %[#{k}: #{l}]}' $HISTORY_GREP_TEMPFILE`"
			zle -R
			read -k key
	if [ -n "${HISTORY_MENU_KEYS[$key]}" ]; then
			 zle -U "`head -${HISTORY_MENU_KEYS[$key]} $HISTORY_GREP_TEMPFILE | tail -1 | perl -pe 's/\\\\n/\\021\\n/g'`"
				zle -R
	fi
	zle -R -c
	rm -f $HISTORY_GREP_TEMPFILE
	fi
}
# history-grep へのキー割り当て
zle -N history-grep-menu
bindkey "^[r" history-grep-menu
 
############################################################
# zawを読み込む (全く使ってない)
############################################################
if [ -e  $zsh_dir/zaw/zaw.zsh ] ; then
	source $zsh_dir/zaw/zaw.zsh
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
# Directory BookMark
############################################################
if [ -e $zsh_dir/bookmark.zsh ] ; then
		source $zsh_dir/bookmark.zsh
fi

############################################################
# zsh_command_not_found  存在しないコマンドを実行→ 近いパッケージを表示
############################################################
local cmd_nfound=/etc/zsh_command_not_found
if [ -e $cmd_nfound ] ; then
	source $cmd_nfound
fi

setopt auto_name_dirs  # !!!

# M-? で which

#-----------------------------------------------------------
#
#-----------------------------------------------------------
# 256色確認
function pcolor() {
	for ((f = 0; f < 255; f++)); do
		printf "\e[38;5;%dm %3d*■\e[m" $f $f
		if [[ $f%8 -eq 7 ]] then
			printf "\n"
		fi
	done
echo
}

#=========================================
local DEFAULT=$'%{[m%}'
local RED=$'%{[1;31m%}'
local GREEN=$'%{[1;32m%}'
local YELLOW=$'%{[1;33m%}'
local BLUE=$'%{[1;34m%}'
local PURPLE=$'%{[1;35m%}'
local LIGHT_BLUE=$'%{[1;36m%}'
local WHITE=$'%{[1;37m%}'

# カレントに候補が無い場合のみcdpath 上のディレクトリが候補となる。
# zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#
# # cdpath 上のディレクトリは補完候補から外す
# # zstyle ':completion:*:path-directories' hidden true
############################################################
# 補完候補表示の際、グループ名表示し、グループごとに表示する
############################################################
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# # したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

############################################################
# auto-fu インクリメンタルに補完候補を表示
############################################################
#autofu=$zsh_dir/auto-fu.zsh
#if [ -e $autofu ] ; then
#	source $autofu
	zle-line-init () {
		auto-fu-init;
	}
#	zle -N zle-line-init
#	zstyle ':auto-fu:var' disable magic-space
#	##	unsetopt autoremoveslash
#fi
############################################################
# サークルのサーバへのssh接続を楽にする
#   IPアドレスの4オクテット目の入力だけで接続可能
#   ただし、ユーザ名の指定は l オプション必須
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

function color_test {
	if [ $# -lt 2 ]; then
		echo "color_test message number"
	else
		echo "\033[38;05;${2}m${1}\033[0m"
	fi
}

# alias diff mode?
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
alias ndate='date +%m%d_%H:%M:%S'

############################################################
# setting for task (task management tool on shell)
############################################################
alias taskshell='ZDOTDIR=~/.task zsh'
compdef _task task

