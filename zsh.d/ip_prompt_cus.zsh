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

# $fg[色名]/bg[色名]$reset_color   などの色表示の書き方ができる

# プロンプトに escape sequence (環境変数) を通す
setopt prompt_subst
autoload colors -U && colors
autoload zsh/terminfo

# ipアドレスを参照する
get-ipaddr() {
  # get NIC list
	local devices="`cat /proc/net/arp | sed '1d' |  awk '{print $6}'`"
  # num of NICs
  local numof_dev=`echo "$devices" | wc -l`
  # reset file
  cat /dev/null > /tmp/.inet
  # check ip-addr of all nics
  for i in `seq -s' ' 1 1 $numof_dev`
  do
      focus_dev=`echo "$devices" | cat -n | grep $i | awk '{print $2}'`
      inet_line=`/sbin/ifconfig $focus_dev | grep -v inet6 | grep inet`
      /sbin/ifconfig $focus_dev | grep -v inet6 | grep inet > /dev/null 
      if [ $? -eq 0 ]; then
          echo $inet_line | cut -d : -f2 | cut -d' ' -f1 >> /tmp/.inet
          inet_addr=`cat /tmp/.inet`
          return
      fi
  done
}

function select_ipaddr () {
	num_ip=`cat /tmp/.inet | wc -l`
	echo $num_ip
	if [ $num_ip -eq 1 ]; then
		inet_addr=`cat /tmp/.inet`
		return
	fi
	select i in `cat /tmp/.inet`
	do
	if [ -x $i ] ; then
		echo "plz retry."
		continue
	fi
		inet_addr=$i
		break
	done
}

# 関数実行
get-ipaddr 2> /dev/null					# エラーは捨てる
select_ipaddr

# ユーザごとに色を変える
# rootならユーザ名rootを赤で表示する
# 自分のアカウントでない場合は紫っぽい色で表示 
if [ $UID = 0 ] ; then
  U_CLR='red'
elif [ $USER = 'masahiro' ] ; then
  U_CLR='blue'
elif [ $USER = 'ookawa' ] ; then
  U_CLR='cyan'
else
  U_CLR='magenta'
fi

# red green yellow blue magenta cyan white

# ホスト名省略
if [ $HOST = 'iguto-Think' ] ; then
    HOSTNAME='Think'
  H_CLR="green"
elif [ $HOST = 'daisyoohkawa.myhome.cx' ] ; then
  HOSTNAME='HomeSrv'
  H_CLR="blue"
elif [ $HOST = 'poulenc.eng.kagawa-u.ac.jp' ] ; then
  HOSTNAME='poulenc'
  H_CLR="red"
elif [ $HOST = 'stfile.eng.kagawa-u.ac.jp' ] ; then
  HOSTNAME='STFILE'
  H_CLR="yallow"
elif [ $HOST = 'utillo1.eng.kagawa-u.ac.jp' ] ; then
  HOSTNAME='u1'
  H_CLR="cyan"
elif [ $HOST = 'utrillo2.eng.kagawa-u.ac.jp' ] ; then
  HOSTNAME='u2'
  H_CLR="magenta}"
else
    HOSTNAME=$HOST
  H_CLR="magenta"
fi

# set color
GREEN="%{$fg['green']%}"
RED="%{$fg['red']%}"
CYAN="%{$fg['cyan']%}"
BLUE="%{$fg['blue']%}"
YELLOW="%{$fg['yellow']%}"
MAGENTA="%{$fg['magenta']%}"

#=====================================================================

# 文字数に変換 ${#${:-STR}}

# プロンプトの余り部分を埋める
fill_char () {
  # 埋める文字
  fchr="="
  while [ $REMAIN -gt 0 ]
  do
    PROMPT="${PROMPT}${fchr}"
    REMAIN=$((${REMAIN}-1))
  done
}

first_line () {
  HOST=$HOSTNAME
  cwd="`print -P \"%~\"`"  
  USER_AND_HOST="[${USER}@${HOSTNAME}(${inet_addr}):${cwd}]"
  user_host_decolation="[${USER}@${HOSTNAME}(${inet_addr}):]"
  user_host_decolation_size=$(( ${COLUMNS} - ${#${user_host_decolation}} ))
    
# IPアドレス
  REMAIN=$(( ${COLUMNS} - ${#USER_AND_HOST} ))
}

set_color () {

  PROMPT=$'%{$GREEN%}[%{$fg[${U_CLR}]%}${USER}%{${GREEN}%}@%{$fg[${H_CLR}]%}${HOST}%{${GREEN}%}(%{$fg["yellow"]%}${inet_addr}%{$fg['green']%}):%{$fg['blue']%}%${user_host_decolation_size}<...<${cwd}%<<%{$fg['green']%}]%{$fg['cyan']%}'
  fill_char

  s_line_f="-(%#"
  s_line_l=")->> "

  PROMPT=${PROMPT}$'${s_line_f}'$'%(?||%{$fg['red']%}:%{$fg["red"]%}'$ret')'$'%{$fg['cyan']%}${s_line_l}%{$reset_color%}'

}

# コマンド実行前じ実行される特殊関数
precmd() {
	ret=$?
  first_line;
  set_color;
}

