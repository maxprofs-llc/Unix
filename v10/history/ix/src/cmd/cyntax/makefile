LLIB=/n/bowell/usr/src/cmd/lint
VAR=/n/bowell/usr/src/cmd/cyntax/lib
LIB=/usr/lib/cyntax
LINT=/usr/lib/lint
CCOM=$LIB/ccom
CEM=$LIB/cem

#all:V:	libc llib-lc.ln libipc llib-lipc.ln
#
#'^lib(.*)$':R:	'llib-l\1' $VAR/'var\1'
#	/lib/cpp -M llib-l$stem1 |
#	$CCOM `cat $VAR/var$stem1` -llib$stem1 - lib$stem1
#
#'llib-l([^.]*)$':R: $LLIB/'llib-l\1' 'llib-l\1a'
#	sed 's/<label.h>/<sys\/label.h>/' $LLIB/llib-l$stem1 llib-l${stem1}a >llib-l$stem1
#
#'llib-l([^.]*)\.ln$':R:	'llib-l\1'
#	/lib/cpp -C -Dlint llib-l$stem1 | /usr/lib/lint/lint1 -v >llib-l$stem1.ln
#
install: libc llib-lc.ln libipc llib-lipc.ln
	#priv downgrade ffff $prereq
	cp libc $LIB 
	cp libipc $LIB 
	cp llib-lc.ln llib-lc $LINT 
	cp llib-lipc.ln llib-lipc $LINT 
	#
	chmod 664 $LIB/libc
	/etc/chown bin,bin $LIB/libc
	#
	chmod 664 $LIB/libipc
	/etc/chown bin,bin $LIB/libipc
	#
	chmod 664 $LINT/llib-lc.ln $LINT/llib-lc
	/etc/chown bin,bin $LINT/llib-lc.ln $LINT/llib-lc
	#
	chmod 664 $LINT/llib-lipc.ln $LINT/llib-lipc
	/etc/chown bin,bin $LINT/llib-lipc.ln $LINT/llib-lipc

clean:
	>llib-lc
	>llib-lc.ln
	>libc
	>llib-lipc
	>llib-lipc.ln
	>libipc
