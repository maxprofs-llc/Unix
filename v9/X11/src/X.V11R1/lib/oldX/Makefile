
#
# This makefile is automatically generated by imake... do not modify
# or you may lose your changes when imake generates makefiles again.
# Ignore this message if you are not using imake.
#

            TOP = ./../..
             AS = as
             CC = cc
            CPP = /lib/cpp
             LD = ld
           LINT = lint
           MAKE = make
    CDEBUGFLAGS = -O
        DESTDIR =

        INSTALL = install
           TAGS = ctags
         DEPEND = $(DEPENDSRC)/makedepend
          IMAKE = $(IMAKESRC)/imake
            RGB = $(RGBSRC)/rgb
         CFLAGS = $(CDEBUGFLAGS) $(INCLUDES) $(DEFINES)
        LDFLAGS = $(CDEBUGFLAGS) $(SYS_LIBRARIES)
   INSTLIBFLAGS = -c -m 0664
      USRLIBDIR = $(DESTDIR)/usr/lib
         BINDIR = $(DESTDIR)/usr/bin/X11
         LIBDIR = $(DESTDIR)/usr/lib/X11
         INCDIR = $(DESTDIR)/usr/include/X11
   FUTUREINCDIR = $(DESTDIR)/usr/include/X
        FONTDIR = $(DESTDIR)$(LIBDIR)/fonts
         MANDIR = $(DESTDIR)/usr/man/mann
      CLIENTSRC = $(TOP)/clients
        DEMOSRC = $(TOP)/demos
         LIBSRC = $(TOP)/lib
        FONTSRC = $(TOP)/fonts
     INCLUDESRC = $(TOP)/include
      SERVERSRC = $(TOP)/server
        UTILSRC = $(TOP)/util
        HACKSRC = $(TOP)/hacks
         DOCSRC = $(TOP)/doc
      DEPENDSRC = $(UTILSRC)/makedepend
       IMAKESRC = $(UTILSRC)/imake
         RGBSRC = $(UTILSRC)/rgb
        XLIBSRC = $(LIBSRC)/X
         XRMSRC = $(LIBSRC)/Xrm
     TOOLKITSRC = $(LIBSRC)/Xtk
     OLDXLIBSRC = $(LIBSRC)/oldX
    OLDXMENUSRC = $(LIBSRC)/oldXMenu
      OLDXRMSRC = $(LIBSRC)/oldXrm
  OLDTOOLKITSRC = $(LIBSRC)/oldXtk
   EXTENSIONSRC = $(TOP)/extensions
        XMANSRC = $(DOCSRC)/Xlib/Xman
   EXTENSIONLIB = $(EXTENSIONSRC)/lib/libXext.a
           XLIB = $(XLIBSRC)/libX.a
        OLDXLIB = $(OLDXLIBSRC)/liboldX.a
       XTOOLLIB = $(TOOLKITSRC)/libXtk.a
    OLDXTOOLLIB = $(OLDTOOLKITSRC)/liboldXtk.a
    OLDXMENULIB = $(OLDXMENUSRC)/libXMenu.a
         XRMLIB = $(XRMSRC)/libXrm.a
      OLDXRMLIB = $(OLDXRMSRC)/liboldXrm.a
       INCLUDES = -I$(TOP)
      MACROFILE = Sunv9.macros
      IMAKE_CMD = $(NEWTOP)$(IMAKE) -TImake.tmpl \
			-I$(NEWTOP)$(UTILSRC)/imake.includes \
			-s Makefile
         RM_CMD = rm -f *.CKP *.ln *.BAK *.bak *.o core errs ,* *~ *.a \
			tags TAGS make.log

       INCLUDES = -I$(TOP) -I$(INCLUDESRC) -I$(XLIBSRC)
        DEFINES = -DUNIXCONN
   INSTALLFLAGS = -m 0644
           SRCS = *.c
        HEADERS = X10.h

OBJS =\
	XDraw.o \
	XCrAssoc.o \
	XDelAssoc.o \
	XDestAssoc.o \
	XLookAssoc.o \
	XMakeAssoc.o

.c.o:
	$(CC) -c $(CFLAGS) $*.c

all:: liboldX.a

liboldX.a: $(OBJS)
	rm -f $@
	ar clq $@ $(OBJS)
	ranlib $@

lintlib:: llib-loldX.ln

llib-loldX.ln: *.c
	rm -f $@
	$(LINT) -ColdX $(DEFINES) ${INCLUDES} *.c

install:: liboldX.a
	$(INSTALL) $(INSTLIBFLAGS) liboldX.a $(USRLIBDIR)
	ranlib $(USRLIBDIR)/liboldX.a

install:: llib-loldX.ln
	$(INSTALL) $(INSTLIBFLAGS) llib-loldX.ln $(USRLIBDIR)

install:: $(HEADERS)
	@case '${MFLAGS}' in *[i]*) set +e;; esac; \
	for i in $(HEADERS); do \
		(set -x; $(INSTALL) -c $(INSTALLFLAGS) $$i $(INCDIR)); \
	done

depend::
	$(DEPEND) -s "# DO NOT DELETE" $(CFLAGS) $(SRCS)

# structure alignment errors can safely be ignored.
# complaints about qevent can be ignored too.

lint:
	$(LINT) -hubz ${INCLUDES} *.c > lint.log

clean::
	$(RM_CMD) \#*

Makefile:: Imakefile \
	$(UTILSRC)/imake.includes/Imake.tmpl \
	$(UTILSRC)/imake.includes/Imake.rules \
	$(UTILSRC)/imake.includes/$(MACROFILE)
		-rm -f Makefile.bak; mv Makefile Makefile.bak
		$(IMAKE_CMD) -DTOPDIR=$(TOP)

tags::
	$(TAGS) -w *.[ch]
	$(TAGS) -xw *.[ch] > TAGS

install::
	@echo "install done"

Makefiles::

