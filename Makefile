.POSIX:

PREFIX = /usr/local
DESTDIR = bin

all: clean build install

clean:
	rm -f jmu

build: jmu

install: jmu
	mv -- jmu ${PREFIX}/${DESTDIR}

jmu:
	cp jmu.sed jmu
	chmod +x jmu
