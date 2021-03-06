root	regfs	ra	0100
swap	ra	001	20480
swap	ra	011	20480
swap	ra	032	249848
swap	ra	034	249848
dump	bddump	0x2403	280568	249848	# ra33 == crash dumps

bia 2	bi 2	node 2	vec 0x04 voff 0x400

kdb50 0	bi 2	node 4	vec 0x10
dwbua 1	bi 2	node 6 vec 0x30 voff 0x800	# klesi-b
uda50 0	ub 1	reg 0774500 vec 0300
ta 0	uda50 0	unit 0

dwbua 0	bi 2	node 0	vec 0x20 voff 0x200	
uda50 1 ub 0	reg 0172150 vec 0254
uda50 2 ub 0	reg 0160334 vec 0410		# td viking disk
uda50 3	ub 0	reg 0160404 vec 0310		# td viking tape
ta 1	uda50 3	unit 0
kmc11b 0 ub 0	reg 0160200 vec 0600
kdi	1
kmcdk	96
dk 0 ub 0 reg 0167770 vec 0400
dz11 0	ub 0	reg 0160100 vec 0300
cure   0 ub 0	reg 0176070	vec 0210
rcure   0 ub 0	reg 0176070

ra 0	kdb50 0	unit 0
ra 1	kdb50 0	unit 1
ra 2	kdb50 0	unit 2
ra 3	kdb50 0	unit 3
ra 4	uda50 1 unit 0
ra 5	uda50 1 unit 1
ra 6	uda50 1 unit 2
ra 7	uda50 1 unit 3

nautcons 0
fineclock 0
debna 0 bi 2	node 7	vec 0x40

drum	0
console	0
mem	0
stdio	0
ip	32
udp	16
tcp	32
arp	128

ttyld	128
mesgld	300
rmesgld	0
cmcld	0
unixpld	0
dkpld	96
connld	0
cdkpld	0
ipld	0
udpld	0
bufld	4
tcpld	0

regfs	15
procfs	0
msfs	0
netafs	0
netbfs	0
errfs	0
pipefs	0
