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
