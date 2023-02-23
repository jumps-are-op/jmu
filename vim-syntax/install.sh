#!/bin/sh

# Made by jumps are op
# This software is under GPL version 3 and comes with ABSOLUTELY NO WARRANTY

[ $# != 1 ] && { cat <<-EOF
		USAGE: install.sh PATH/TO/VIM/RUNTIME/DIRECTORY
	EOF
	exit 1
}
cp vim-syntax/* "$1"
