# zshプロンプト 表示フォーマット
#
# PS1:通常のプロンプト
# PS2:for文使用時などで表示される
# SPROMPT:間違い修正のコレクト機能を有効にしているときに使う。
#
# autoload colors -U && colors があれば、
# $fg[色名]/bg[色名]$reset_color   などの色表示の書き方ができる
# 
# %%    : %を表示
# %)    : )を表示
# %l    : 端末名省略形
# %M    : FQDN
# %m    : サブドメイン
# %n    : ユーザ名nnnnnnn
# %y    : 端末名
# %#    : rootなら#、それ以外なら%を表示
# %?    : 直前に実行したコマンドの結果コード
# %d    : ワーキングディレクトリ
# %/    : ワーキングディレクトリ
# %e~     : ホームディレクトリからのパス
# %h    : ヒストリ番号
# %!    : ヒストリ番号
# %S %s : 挟んだ部分を反転
# %U %u : 挟んだ部分に下線
# %B %b : 挟んだ部分を強調
# %t    : 時計表示(12時間)
# %T    : 時計表示(24時間表示)
# %*    : 時計表示(24時間秒付き)
# %w    : 日付表示
# %W    : 年月日(mm/dd/yy)
# %D    : yy-mm-dd

# %N    : シェル名
# %i    : %Nによって与えられるスクリプト、ソース、シェル関数で現在実行されている行番号 (debug用)
#
# 特権ユーザと一般ユーザのプロンプトを1行で設定する
# PROMPT='(!.特権ユーザ用.一般ユーザ用)'



# プロンプトに escape sequence (環境変数) を通す
setopt prompt_subst
autoload colors -U && colors
autoload zsh/terminfo
# $fg[色名]/bg[色名]$reset_color   などの色表示の書き方ができる
# begin ------------------
# rootのプロンプトカラー変更 test http://www.q-eng.imat.eng.osaka-cu.ac.jp/~        ippei/unix-tips/zsh.html から
# end -------------------
#

# ipアドレスを参照する
get-ipaddr() {
	# get NIC list
#	local devices="`cat /proc/net/dev | awk '{print $1}' | sed '1,3d' | sed s/://`"
	local devices="`cat /proc/net/dev | awk '{print $1}' | sed '1,3d' | cut -d: -f1`"
#	echo devices : $devices
	
	
	# num of NICs
	local numof_dev=`echo "$devices" | wc -l`
#	echo numof_dev : $numof_dev
	# check ip-addr of all nics
	
	for i in `seq -s' ' 1 1 $numof_dev`
	do
#			echo i : $i
			focus_dev=`echo "$devices" | cat -n | grep $i | awk '{print $2}'`
#			echo focus_dev : $focus_dev
			/sbin/ifconfig $focus_dev | grep -v inet6 | grep inet > /tmp/.inet
			cat /tmp/.inet | grep inet > /dev/null
			if [ $? -eq 0 ]; then
					inet_line=`cat /tmp/.inet`
					echo $inet_line | cut -d : -f2 | cut -d' ' -f1 > /tmp/.inet
					inet_addr=`cat /tmp/.inet`
		#echo $inet_addr
					return 
			fi
	done
x}

get-ipaddr


# ユーザごとに色を変える
# rootならユーザ名rootを赤で表示する
# 自分のアカウントでない場合は紫っぽい色で表示 
if [ $UID = 0 ] ; then
	MYUSER='root'
	U_CLR='red'
elif [ $USER = 'masahiro' ] ; then
    MYUSER='M'
	U_CLR='blue'
elif [ $USER = 'ookawa' ] ; then
	MYUSER='OKW'
	U_CLR='cyan'
	
else
	MYUSER=$USER
	U_CLR='magenta'
fi

# red green yellow blue magenta cyan white

# ホスト名省略
#if [ $HOST = 's09t214-laptop' ] ; then
#   	HOSTNAME='NOTE'
#	H_CLR='green'
#elif [ $HOST = 'daisyoohkawa.myhome.cx' ] ; then
#	HOSTNAME='HS'
#	H_CLR='blue'
#elif [ $HOST = 'poulenc.eng.kagawa-u.ac.jp' ] ; then
#	HOSTNAME='poulenc'
#	H_CLR='red'
#elif [ $HOST = 'stfile.eng.kagawa-u.ac.jp' ] ; then
#	HOSTNAME='STFILE'
#	H_CLR='yellow'
#elif [ $HOST = 'haydn11.eng.kagawa-u.ac.jp' ] ; then
#	HOSTNAME='U1'
#	H_CLR='cyan'
#elif [ $HOST = 'haydn12.eng.kagawa-u.ac.jp' ] ; then
#	HOSTNAME='U2'
#	H_CLR='magenta'
#else
#   	HOSTNAME=$HOST
#	H_CLR='magenta'
#fi

# set color

GREEN="%{$fg['green']%}"
RED="%{$fg['red']%}"
CYAN="%{$fg['cyan']%}"
BLUE="%{$fg['blue']%}"
YELLOW="%{$fg['yellow']%}"
MAGENTA="%{$fg['magenta']%}"

BGREEN="%{$terminfo['bold']$fg['green']%}"
BRED="%{$terminfo['bold']$fg['red']%}"
BCYAN="%{$terminfo['bold']$fg['cyan']%}"
BBLUE="%{$terminfo['bold']$fg['blue']%}"
BYELLOW="%{$terminfo['bold']$fg['yellow']%}"
BMAGENTA="%{$terminfo['bold']$fg['magenta']%}"

BRESET='%{$terminfo['srg0']%}'

#PROMPT=$'\n%{$fg['cyan']%} ‡‡‡‡‡‡ † ∬  ⇦  ↻ ▨ ▨ ▨ ▨ ▨▨▨  ∑→ →(%{$fg['magenta']%}$inet_addr%{$fg['cyan']%})╋╋╋╋ ░ ░ ░ ░ ░ ░ ░ ░ ░ ░ ░ ░
#%{$fg[${U_CLR}]%}${MYUSER}%{$fg[${H_CLR}]%}@${HOSTNAME} %2~:%{$reset_color%}'
#=====================================================================

# 文字数に変換 ${#${:-STR}}

# 表示したいコンテンツ？
# ユーザ名@ホスト名
# $USER そのまま

fill_char () {
# プロンプトの余り部分を埋める
	# 埋める文字
	fchr="="
	while [ $REMAIN -gt 0 ]
	do
		PROMPT="${PROMPT}${fchr}"
		REMAIN=$((${REMAIN}-1))
	done
}
first_line () {
	HOST=$HOSTNAME   # 要省略
# カレントディレクトリ
	cwd=$(ruby -e "print ENV['PWD'].gsub(ENV['HOME'], '~')")
		
	USER_AND_HOST="[${USER}@${HOST}(${inet_addr}):${cwd}]"
	user_host_decolation="[${USER}@${HOST}(${inet_addr}):]"
	user_host_decolation_size=$(( ${COLUMNS} - ${#${user_host_decolation}} ))
#	p_size=${#${:-${USER_AND_HOST}}}
		
# IPアドレス
	REMAIN=$(( ${COLUMNS} - ${#USER_AND_HOST} ))
#	PROMPT=$'\n${USER_AND_HOST}'
		
#	fill_char
}

second_line () {
	s_line="〓―(%#:%?)->> "
}



set_color () {

	PROMPT=$'%{$fg['green']%}[${USER}@${HOST}(%{$fg['yellow']%}${inet_addr}\
%{$fg['green']%}):%{$fg['blue']%}%${user_host_decolation_size}<...<${cwd}%<<%{$fg['green']%}]%{$fg['cyan']%}'
	fill_char

	s_line_f="〓―(%#"
	# $?
	s_line_l=")->> "

	PROMPT=${PROMPT}$'${s_line_f}'$'%0(?||%{$fg['yellow']%}:%{$fg['red']%}'$l_c')'$'%{$fg['cyan']%}${s_line_l}%{$reset_color%}'

	# red green yellow blue magenta cyan white
}

# コマンド実行前じ実行される特殊関数
precmd() {
	local l_c=$?
	second_line;
	first_line;
	set_color;
}

# プロンプト
# WINDOWはscreen実行時のスクリーン番号表示 (prompt_subset必要)
#PS1=$'\n%{\e[${PSCOLOR}m%}${MYUSER}@${HOSTNAME}:%~ ${WINDOW:+"[$WINDOW]"}%#%{\e[00m%} '

# sudo時色を変える
