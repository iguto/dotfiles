#===========================================================
#  alias
#===========================================================
## 色表示関連
# less 色表示を残す? もとの表示を維持しようとする
alias grep="grep --color='always'"
alias less='less -RFX'

if [ "$(uname)" = "Darwin" ]; then
  alias ls="ls -G -hvF"
else
  alias ls="ls --color=always -hvF"
  alias ll='ls -lF' la='ls -aF' laa='la | grep ^\.' lla='la -l'
  alias lsd='ls -d *(/)'
fi

## 実行確認
# -i : 上書き確認,
# -u : 移動元の更新日時が更新先より古いか、同じ場合は上書きしない
# -b : 上書き必要がある場合、バックアップファイルを作成する
# -S SUFFIX : SUFFIXをバックアップファイルに付け加える文字列とする
alias mv='mv -i'
alias cp='cp -i'

alias e="emacs"
alias vimr='vim -R' # Read only vim

# bell
alias bell='echo -e "\a"'

alias -g ...='../..'
alias -g ....='../../..'
alias -g G="| grep"
alias -g H='| head'
alias -g L='| less'
alias -g T='| tail'
alias -g W='| wc -l'
alias -g N='/dev/null'

# git alias
alias gs='git status -s'
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gdd='git diff --cached'

alias rspec='rspec -c' # rspec color

# alias diff mode
which colordiff > /dev/null
[ $? -eq 0 ] && alias diff='colordiff'
alias diff='diff -u'

alias ndate='date +%m%d_%H:%M:%S'



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

# 256色表示を個別にテストするための関数
function color_test {
  if [ $# -lt 2 ]; then
    echo "color_test message number"
  else
   echo "\033[38;05;${2}m${1}\033[0m"
  fi
}
