function switch_emacs()
{
	if [ ${SSH_CONNECTION:-""} = "" ]; then
		# on local
		/usr/bin/emacs $*
	else
		# on remote
		/usr/bin/emacs -nw $*
	fi
}
