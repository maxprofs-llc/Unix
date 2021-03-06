M4 = @m4

MHOME = /usr/lib/monk

INSDIR = $(MHOME)/db

COMPRESS = $(MHOME)/compress -d .

FRC =

DBS = \
	acm \
	attrib \
	centerpb \
	cspress \
	form1 \
	global \
	im \
	kluwer \
	letter \
	macro \
	memo \
	model \
	research \
	rp \
	song \
	tc \
	tm

CDBS = \
	acm.comp \
	centerpb.comp \
	cspress.comp \
	form1.comp \
	global.comp \
	im.comp \
	kluwer.comp \
	letter.comp \
	memo.comp \
	model.comp \
	research.comp \
	rp.comp \
	song.comp \
	tc.comp \
	tm.comp

all: doc comp

doc: $(DBS)

comp: $(CDBS)

acm: \
	acm.m \
	global.h \
	macro.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h acm.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> acm
	@echo "acm updated"

acm.comp: acm attrib $(FRC)
	$(COMPRESS) acm

attrib: \
	attrib.m \
	list.h \
	macro.h \
	style.h \
	m4.h \
	$(FRC)
	$(M4) m4.h attrib.m | sed \
	-e "s/^\([.']\)[	 ]*\([a-z][a-z]\) /\1\2/" \
	-e "s/^\([.']\)[	 ]*/\1/" \
	-e '/^.\\"/d' \
	-e 's/[	 ]*\\".*//' \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> attrib
	@echo "attrib updated"

centerpb: \
	centerpb.m \
	macro.h \
	m4.h \
	$(FRC)
	$(M4) m4.h centerpb.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> centerpb
	@echo "centerpb updated"

centerpb.comp: centerpb attrib $(FRC)
	$(COMPRESS) centerpb

cspress: \
	cspress.m \
	global.h \
	macro.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h cspress.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> cspress
	@echo "cspress updated"

cspress.comp: cspress attrib $(FRC)
	$(COMPRESS) cspress

form1: \
	form1.m \
	global.h \
	macro.h \
	m4.h \
	$(FRC)
	$(M4) m4.h form1.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> form1
	@echo "form1 updated"

form1.comp: form1 attrib $(FRC)
	$(COMPRESS) form1

global: \
	global.m \
	envir.h \
	envir.m \
	global.h \
	index.m \
	list.h \
	list.m \
	macro.h \
	preproc.h \
	preproc.m \
	section.h \
	section.m \
	set.m \
	special.m \
	style.h \
	style.m \
	t_contents.m \
	whitespace.m \
	m4.h \
	$(FRC)
	$(M4) m4.h global.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> global
	@echo "global updated"

global.comp: attrib global macro $(FRC)
	$(COMPRESS)

im: \
	im.m \
	coversheet.h \
	coversheet.m \
	envir.h \
	macro.h \
	preproc.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h im.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> im
	@echo "im updated"

im.comp: im attrib $(FRC)
	$(COMPRESS) im

kluwer: \
	kluwer.m \
	global.h \
	macro.h \
	section.h \
	m4.h \
	$(FRC)
	$(M4) m4.h kluwer.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> kluwer
	@echo "kluwer updated"

kluwer.comp: kluwer attrib $(FRC)
	$(COMPRESS) kluwer

letter: \
	letter.m \
	macro.h \
	m4.h \
	$(FRC)
	$(M4) m4.h letter.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> letter
	@echo "letter updated"

letter.comp: letter attrib $(FRC)
	$(COMPRESS) letter

macro: \
	macro.m \
	macro.h \
	style.h \
	m4.h \
	$(FRC)
	$(M4) m4.h macro.m | sed \
	-e "s/^\([.']\)[	 ]*\([a-z][a-z]\) /\1\2/" \
	-e "s/^\([.']\)[	 ]*/\1/" \
	-e '/^.\\"/d' \
	-e 's/[	 ]*\\".*//' \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> macro
	@echo "macro updated"

memo: \
	memo.m \
	macro.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h memo.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> memo
	@echo "memo updated"

memo.comp: memo attrib $(FRC)
	$(COMPRESS) memo

model: \
	model.m \
	global.h \
	macro.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h model.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> model
	@echo "model updated"

model.comp: model attrib $(FRC)
	$(COMPRESS) model

research: \
	research.m \
	global.h \
	macro.h \
	m4.h \
	$(FRC)
	$(M4) m4.h research.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> research
	@echo "research updated"

research.comp: research attrib $(FRC)
	$(COMPRESS) research

rp: \
	rp.m \
	macro.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h rp.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> rp
	@echo "rp updated"

rp.comp: rp attrib $(FRC)
	$(COMPRESS) rp

song: \
	song.m \
	global.h \
	m4.h \
	$(FRC)
	$(M4) m4.h song.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> song
	@echo "song updated"

song.comp: song attrib $(FRC)
	$(COMPRESS) song

tc: \
	tc.m \
	coversheet.h \
	coversheet.m \
	envir.h \
	macro.h \
	preproc.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h tc.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> tc
	@echo "tc updated"

tc.comp: tc attrib $(FRC)
	$(COMPRESS) tc

tm: \
	tm.m \
	coversheet.h \
	coversheet.m \
	envir.h \
	macro.h \
	preproc.h \
	titlebox.h \
	titlebox.m \
	m4.h \
	$(FRC)
	$(M4) m4.h tm.m | sed \
	-e 's/^|||*/|/' \
	-e '/^|[| ]*$$/d' \
	-e 's/\\n\([0-9]\)/\1/g' \
	-e 's/\\n\$$i/$$i/g' \
	-e 's/^[	 ]*//' \
	-e 's/\\n /\\n/g' \
	> tm
	@echo "tm updated"

tm.comp: tm attrib $(FRC)
	$(COMPRESS) tm

clean:

clobber: clean
	-rm -f $(DBS) $(CDBS)

install: all
	cp $(DBS) $(CDBS) $(INSDIR)

debug: doc
	cp $(DBS) $(INSDIR)

summary: $(DBS)
	@for i in $(DBS) ; \
	do \
		echo -e "\n\n$$i doc type\n" ; \
		grep '|comment<summary: ' $$i | \
		    sed -e 's/|comment<summary: \(.*\)>/\1/' | sort -u ; \
	done > summary
	@echo -e '\n' >> summary
	@cat todo.m >> summary
	@echo summary updated
