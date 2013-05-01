function switch_emacs()
{
	if [ -e /usr/local/bin/emacs ]; then
		local emacs=/usr/local/bin/emacs
	else
		local emacs=/usr/bin/emacs
	fi

	if [ ${SSH_CONNECTION:-""} = "" ]; then
		# on local
		$emacs $*
	else
		# on remote
		$emacs -nw $*
	fi
}
