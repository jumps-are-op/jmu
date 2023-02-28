TO = /usr/local/bin
VIMRUNTIME =

install: jmu.sed
	cp -- jmu.sed "${TO}/jmu"
install-syntax:
	@[ "${VIMRUNTIME}" ] || { echo "You need to specify VIMRUNTIME on the commandline, e.g."; echo "make VIMRUNTIME=/path/to/vim/runtime"; exit 1 ;}
	./vim-syntax/install.sh "${VIMRUNTIME}"
	
