#! /usr/bin/zsh

histf=$HOME/.zsh_history

function zcd {
		if [ $# -eq 1 ]; then
				builtin cd $1
				if [ $? -ne 0 ] ; then
						return 1
				fi
				sed -i '$ d' $histf
				echo "cd" $PWD >> $histf
				fc -R
		else
				builtin cd $*
		fi
}

# compdef '_files -/' _directory_stack  zcd
#compdef _cd _directory_stack  zcd
compdef _cd  zcd
