.POSIX:
PREFIX = /usr/local
DESTDIR = bin

install: jmu
	mv -- jmu ${PREFIX}/${DESTDIR}

jmu:
	cp jmu.sed jmu
