#
# reorder gives an editor command for most common terminals
# (in reverse order from n'th to 1'st most commonly used)
# to move them to the front of termcap
#
termcap.obj: termcap.src
	ed - termcap.src < reorder
install: termcap.obj
	cp termcap.obj ${DESTDIR}/etc/termcap
clean:
	rm -f termcap.obj
tabset:	/tmp
	mkdir /usr/lib/tabset
	cp tabset/* /usr/lib/tabset
VGRIND=	csh /usr/ucb/vgrind
vgrind:
	${VGRIND} -n -h "Terminal Capibility Data Base" \
	termcap.src reorder makefile
