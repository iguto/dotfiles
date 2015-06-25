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
  #fchr="⇉"
  #fchr="■"
  #fchr="✚"
  fchr="-"
  #fchr="❚"
  while [ $REMAIN -gt 0 ]
  do
    PROMPT="${PROMPT}${fchr}"
    REMAIN=$((${REMAIN}-1))
  done
}

first_line () {
  HOST=$HOSTNAME
  cwd=`print -P "%~"`
	if [ $cwd = "~cwd" ]; then
		cwd=`print -P "%~"`
	fi
  USER_AND_HOST="[${USER}@${HOSTNAME}:${cwd}]"
  user_host_decolation="[${USER}@${HOSTNAME}:]"
  # user_host_decolation="[${USER}@${HOSTNAME}(xxx.xxx.xxx.xxx):]"
  user_host_decolation_size=$(( ${COLUMNS} - ${#${user_host_decolation}} ))

  # IPアドレス
  REMAIN=$(( ${COLUMNS} - ${#USER_AND_HOST} ))
}

set_color () {

  #PROMPT=$'%{$terminfo['bold']%}%{$GREEN%}[%{$fg[${U_CLR}]%}${USER}%{${GREEN}%}@%{$fg[${H_CLR}]%}${HOST}%{${GREEN}%}(%{$fg["yellow"]%}${inet_addr}%{$fg['green']%}):%{$fg['blue']%}%${user_host_decolation_size}<...<${cwd}%<<%{$fg['green']%}]%{$fg['cyan']%}'
  PROMPT=$'%{$GREEN%}[%{$fg[${U_CLR}]%}${USER}%{${GREEN}%}@%{$fg[${H_CLR}]%}${HOST}%{${GREEN}%}:%{$fg['blue']%}%${user_host_decolation_size}<...<${cwd}%<<%{$fg['green']%}]%{$fg['cyan']%}'

  ##
  # デモ用プロンプト ユーザ名、ホスト名、IPアドレスをマスク
  ##
  #PROMPT=$'%{$terminfo['bold']%}%{$GREEN%}[%{$fg[${U_CLR}]%}user%{${GREEN}%}@%{$fg[${H_CLR}]%}HostName%{${GREEN}%}(%{$fg["yellow"]%}xxx.xxx.xxx.xxx%{$fg['green']%}):%{$fg['blue']%}%${user_host_decolation_size}<...<${cwd}%<<%{$fg['green']%}]%{$fg['cyan']%}'
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
