TO = /usr/local/bin
VIMRUNTIME =

install: jmu.sed
	cp -- jmu.sed "${TO}/jmu"
install-syntax:
	if [ "${VIMRUNTIME}" = "" ];then echo "You need to specify VIMRUNTIME on the commandline, e.g."; echo "make VIMRUNTIME=/path/to/vim/runtime"; exit 1;fi
	./vim-syntax/install.sh "${VIMRUNTIME}"
	
