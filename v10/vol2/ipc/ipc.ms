.so ../ADM/mac
.XX ipc 523 "Interprocess Communication"
.ND
.TL
Interprocess Communication
.br
in the Ninth Edition
.UX
System
.AU
D. L. Presotto
D. M. Ritchie
.AI
AT&T Bell Laboratories
Murray Hill, New Jersey 07974
.AB
.PP
When processes wish to communicate, they must first establish communication,
and then decide what to say.
The stream mechanisms introduced in the Eighth Edition Unix system,
which have now become part of AT&T's Unix System V|reference(systemv streams),
provide a flexible way for processes
to speak with devices and with
each other:
an existing stream connection is named by a file descriptor,
and the usual read, write, and I/O control requests apply.
Processing modules may be inserted dynamically
into a stream connection, so
network protocols, terminal processing, and device drivers separate
cleanly.
.PP
Simple extensions provide new ways of establishing communication.
In our system, the traditional Unix IPC mechanism, the pipe, is
a cross-connected stream.
A new request associates a stream with a named file.
When the file is opened,
operations on the file are operations on the
stream.
Open files may be passed from
one process to another over a stream.
.PP
These low-level mechanisms allow 
construction of flexible and general
routines for connecting local and remote processes.
.AE
.2C
.NH 1
Introduction
.PP
The work reported here provides convenient ways
for programs to establish communication with unrelated
processes, on the same or different machines.
The communication we are interested in is conducted by
ordinary read and write calls, occasionally supplemented
by I/O control requests, so that it resembles\(emand, where possible,
is indistinguishable from\(emI/O to files.
Moreover, we wish to commence communication in ways that resemble
the opening of ordinary files, or at least takes advantage of
the properties of the file system name space.
.PP
In particular, we study how to
.IP 1)
provide objects nameable as files that invoke useful services,
such as connecting to other machines over various media,
.IP 2)
make it easy to write the programs that provide the services.
.NH 2
Recapitulation
.PP
The Eighth Edition system introduced a new way of communicating with
terminal and network devices|reference(ritchie bltj stream),
and a generalization of the internal interface to the
file system|reference(weinberger remote)|reference(killian processes).
Because the new mechanisms build on these ideas, we
review the nomenclature and mechanisms
of our I/O and file systems.
.NH 2
Streams
.PP
A
.I "stream
is a full-duplex connection between a process and a device
or another process.
It consists of several linearly connected processing modules,
and is analogous to a Shell pipeline, except that
data flows in both directions.
The modules in a stream communicate
by passing messages to their neighbors.
A module provides only one entry point to each neighbor, namely
a routine that accepts messages.
.PP
At the end of the stream closest to the process
is a set of routines that provide the interface to the rest of the system.
A user's
.I "write
and
I/O control requests are turned into messages sent along the stream,
and
.I read
requests take data from the stream and pass it to the user.
At the other end of the stream is either a
device driver module, or another process.
Data arriving from the stream at a driver module
is transmitted to the device, and
data and state transitions detected by the device are
composed into messages and sent into the stream towards the user process.
Pipes, which are streams connecting processes,
are bidirectional;
a writer at either end generates stream messages that are picked up by the reader
at the other.
.PP
Intermediate modules process messages in various ways.
They come in pairs, for handling messages
in each of the two directions, and each pair is symmetrical;
their read and write interfaces are identical.
.PP
The end modules in a device stream become connected automatically when
the process opens the device;
streams between processes are created by a
.I pipe
call.
Intermediate modules are attached dynamically by request of the user's program.
They are addressed like a stack with its top close to the process,
so installing one is called `pushing' a new module.
.PP
For example,
Figure 1 shows a stream device that has just
been opened.
The top-level routines, drawn as a pair of half-open rectangles
on the left, are invoked by users'
.I read
and
.I write
calls.
The
writer
routine sends messages to the device driver shown on the right.
Data arriving from the device becomes
messages sent to the top-level
reader
routine, which returns the data to the user process
when it executes
.I read .
.1C
.so pfig1
.2C
.PP
Figure 2 shows a stream with intermediate modules.
This arrangement might be used when a terminal is connected to the computer
through a network.
The leftmost intermediate module carries out processing
(such as character-erase and line-kill) needed for terminals, while
the rightmost intermediate module does the
flow- and error-control
protocol needed to interface to the network.
.1C
.so pfig2
.2C
.PP
Finally, Figure 3
shows the connections for a pipe.
.1C
.so pfig3
.2C
.NH 2
File Systems
.PP
Weinberger|reference(weinberger remote)
generalized the file system
by identifying a small set of primitive operations on files
(read, write, look up name, truncate, get status, etc.: a total of 11)
and modifying the
.I mount
request so that it specifies a file system type and, where appropriate,
a stream.
When file operations are requested, the calls to the underlying
primitives are routed through a switch table indexed by the
type.
Where the standard file system type performs operations directly
on a disk,
a second type generates remote procedure calls
across the associated stream.
At the other end of the stream, which usually goes over
a network to another machine, is a server process
that answers the calls to read and write data and perform the other operations.
This scheme thus provides a remote file system.
In general structure, this arrangement is analogous
to that used by AT&T's RFS|reference(RFS att remote file system)
and Sun Microsystems' NFS|reference(NFS sun remote file system).
.PP
Pike's `face server'|reference(pike face)
appears to be an ordinary remote file system,
but his server simulates a hierarchy containing images classified by
machine, person name, and resolution.
The apparent structure of the hierarchy as viewed by
a client differs considerably from
its actual layout on the server's machine.
.PP
Killian|reference(killian processes)
added a file system type that
appears to be a directory containing the names (process ID numbers)
of currently running processes.
Once a process file is opened, its memory may be read or written,
and control operations can start it or stop it.
This simplifies the construction of sophisticated debuggers,
for example Cargill's process-inspector
.I pi |reference(cargill blit pi 1983).
.NH 1
Establishing Communication
.PP
Traditional Unix systems provide few ways for a process
to establish communication with another.
The oldest one, the pipe, has proved astonishingly valuable
despite its limitations, and indeed remains central in the design
we shall describe.
Its cardinal limitation is, of course, that it is anonymous,
and cannot be used to create a channel between unrelated processes.
.PP
More recently,
AT&T's System V has offered a variety of communication mechanisms including
semaphores, messages, and shared memory.
They are all useful in certain circumstances, but programs that
use them are all special-purpose; they know that they are communicating
over a certain kind of channel, and must use special calls and techniques.
System V also provides named pipes (FIFOs).
They reside in the file system, and ordinary I/O operations
apply to them.
They can provide a convenient place for processes to meet.
However, because the messages of all writers are intermingled,
writers must observe a carefully designed, application-specific protocol
when using them.
Moreover, FIFOs supply only one-way communication;
to receive a reply from a process reached through
a FIFO, a return channel must be constructed somehow.
.PP
Berkeley's 4.2 BSD system introduced
.I sockets
(communication connection points)
that exist in domains (naming spaces).
The design is powerful enough to provide most of the needed facilities,
but is uncomfortable in various ways.
For example, unless extensive libraries are used, creating a new
domain implies additions to the kernel.
Consider the problem of adding a `phone' domain, in which the addresses
are telephone numbers.
Should complicated negotiations with various kinds of
automatic dialers be added to the kernel?
If not, how can the required code be invoked in user mode
when a program calls
4.2 BSD's
.I connect
primitive?
.PP
Another problem with the socket interface is that it exposes
peculiarities of the domain;
various domains support very different kinds of name
(for example, 32-bit Internet address versus character string), and it is difficult
to deal with the names in a general way.
Similarly, the details of option processing and other aspects of
each domain's protocols complicate an interface that attempts generality.
.NH 1
New System Mechanisms
.PP
Two small additions to the operating system allowed us to build
a variety of communication mechanisms, which will be
described below.
.NH 2
Generalized Mounting
.PP
Traditionally, the
.I mount
request attaches a disk containing
a new piece of the file system tree at a leaf of the existing structure.
In the Ninth Edition, it takes the form
.P1
mount(type, fd, name, flag);
.P2
in which
.I type
identifies the kind of file system,
.I fd
is a file descriptor,
.I name
is a string identifying a file, and
.I flag
may specify a few options.
Like its original version, this call attaches a new file system structure
atop the file
.I name
in the existing file hierarchy.
The operating system gains access to the contents of newly-attached file tree
by communicating over the descriptor
.I fd,
according to a protocol appropriate for the new file system
.I type.
For example, ordinary disk volumes have type
.I ordinary,
and the file descriptor is the special file for
the disk, while
remote file systems use type
.I remote,
and the descriptor
refers to a stream connection to a server that understands
the appropriate RPC messages.
Some types are handled entirely internally;
for example, the `proc' type ignores the file descriptor.
.PP
We added a new, very simple, file system type.
Its
.I mount
request merely attaches the file descriptor (which must be a stream) to
the file.
Subsequently, when processes open and do I/O on that file,
their requests refer to the stream mounted on the file.
Often, the stream is one end of a pipe created by a server
process, but it can equally well be a connection to a device,
or a network connection to a process on another machine.
The effect is similar to a System V FIFO that has already been opened
by a server, but more general: communication is full-duplex,
the server can be on another machine, and (because the connection is a stream),
intermediate processing modules may be installed.
.NH 2
Passing Files
.PP
By itself, a mounted stream shares an important difficulty
of the FIFO;
several processes attempting to use it simultaneously must
somehow cooperate.
Another addition facilitates this cooperation:
an open file may be passed
from one process to another across a pipe connection.
The primitives may be written
.P1
sendfile(wpipefd, fd);
.P2
in the sender process, and
.P1
(fd1, info) = recvfile(rpipefd);
.P2
in the receiver.
By using
.I sendfile,
the sender transmits a copy of its file descriptor
.I fd
over the pipe to the receiver;
when the receiver accepts it by
.I recvfile,
it gains a new open file denoted by
.I fd1.
(Other information, such as the user- and group-id of the sender,
is also passed.)
The facility may be used only locally, over a pipe;
we do not attempt to extend it to remote systems.
.PP
A similar facility is available in the 4.3 BSD system|reference(bsd43manual),
but is little-used, possibly because in earlier versions
the related socket facilities were buggy.
It will appear in future versions of Unix System V.
.NH 1
Simple Examples
.PP
A graded set of examples will illustrate how these mechanisms
can solve problems that vex other systems.
.NH 2
Talking to Users
.PP
When a user logs in to traditional Unix systems, an entry is made in the
.CW /etc/utmp
file, recording the login name and the terminal or network channel
being used.
Although this file is often used merely to show who is where,
it is also used to establish communication with the user.
For example, the
.I write
command and the mail-notification service look up
a user's name, and send a message
to the corresponding terminal.
This simple scheme does not work well with windowing terminals,
because the messages disturb the protocol between
the host and the terminal, and because there is no obvious way
to relate the terminal's special file to a particular window.
Even without windows, there are security problems and other difficulties
that follow from letting users write on each other's terminals.
.PP
We use stream-mounting to interpose a program
between a terminal special file and the terminal itself.
The program, called
.I vismon ,
mounts one end of a pipe on the user's terminal.
Normally it occupies an inconspicuous window, displaying system
activity and announcing arriving mail.
When some other process opens and writes on the special file
for the terminal, the mounted stream receives the data;
.I vismon
creates a new window, and copies this data to it.
The new window has a shell, so that if the message was
from a
.I write
command, the recipient can write back.
.PP
Communication between the terminal and the windowing
multiplexor on the host is not disturbed;
it continues to flow to the terminal itself, not to
.I vismon,
because the
.I mount
operation affects only the interpretation of file names,
not existing file descriptors.
.NH 2
Network Calling: Simple Form
.PP
Making a network connection is a complicated activity.
There is often name translation of various kinds,
and sometimes negotiations with various entities.
With the Datakit\(rg VCS network|reference(datakit asynchronous),
for example, a call is placed
by negotiating with a node controller.
When dialing over the switched telephone system, one must talk
to any of several kinds of automatic dialers.
Setting up a connection on an Internet
under any of the extant protocols requires translation of
a symbolic name to a net address, and then special communication
with the remote host.
These setup protocols should certainly not be in kernel code, so
most systems package them in user-callable libraries.
.PP
With our primitives, it is straightforward to encapsulate a
network-connection algorithm to a single executable program.
A application desiring to make an outward connection calls a simple routine
that creates a pipe, forks, and in the child process executes the
network dialer program.
The dialer passes back either an error code, or a file descriptor
referring to an open connection to the other machine.
The pseudo-code for this library routine,
neglecting error-checking and closing down the pipe, is:
.P1 0
netcall(address)
{	int p[2];

 	pipe(p);
	if (fork()!=0)
		execute("/etc/netcaller",
			address, p[0]);
.P3
	status = wait();
	if (bad(status))
		return(errcode);
	passedinfo = recvfile(p[1]);
	return(passedinfo.fd);
}
.P2
The
.CW /etc/netcaller
program can be arbitrarily complicated, but does not occupy the
same address space as its caller.
In this way, if something in the network interface changes,
only one program needs to be fixed and reinstalled.
Its job is to create the connection, and pass its descriptor
for the open connection; it then terminates, and is no
longer involved in the connection.
Along the way, it may negotiate permissions and provide the caller's
identity reliably, because it can be a privileged (set-uid) program.
Thus, the segregation of the program that does the actual call setup
from its client is important.
When connections are made by library routines,
the operating system must know enough about
the call setup protocols to authenticate the caller to the target system.
In the method described above, this task need not be done in kernel code.
Even shared libraries, which do reduce the bulk of
code included with each program that makes network connections,
run in the protection domain of the person who
executes them.
.NH 2
Process Connections
.PP
Suppose you are writing a multi-player game,
in which several people interact with each other.
One design uses a pair of programs:
a controller process that runs throughout the game and
coordinates
the play, and a player program, with one instance for each player,
that communicates with the controller.
.PP
When the controller starts,
it creates a conventionally-located file, stream-mounts
one end of a pipe on this file,
and waits for connection messages to arrive from players.
When the player program is run, it opens
the communication file, and creates its own pipe.
It starts communication by sending one end of this pipe to the
game controller over the communication file.
.PP
As each passed pipe appears on the controller's connection stream,
it accepts the connection with
.I recvfile.
Thereafter, each player transmits moves and receives replies
over its end of the pipe;
the controller reads players' moves and transmits replies
over the end it received.
It maintains the global state of the game, and uses the
.I select (2)
mechanism
to multiplex connection requests and the communication with the
player programs.
.NH 1
The Connection Server
.PP
The final example illustrates a general
connection server.
It combines ideas used by the initial network-calling
scheme and the game design, described above,
to create a flexible switchboard
through which programs can connect to remote or local services.
.PP
Two things are necessary for handling server-client relationships:
first, some program must establish itself as a server,
and wait for requests for the service;
and second, programs must make requests.
We will first describe the external appearance of the scheme (the
library entry points), then the addressing and naming, and then the implementation.
.PP
A program that desires to make a connection calls the routine
.I ipcopen,
passing a string
of characters that specifies the address and the desired service at
that address.
.P1
fd = ipcopen(service);
.P2
The
.I ipcopen
routine returns a file descriptor connected to the requested server.
If it fails, a string describing the error is available.
.PP
In order to announce a service,
.I ipccreat
is used;
its argument is a string that names the service.
The return value is a file descriptor
.I fd
that is a channel on which connection requests will be sent.
.P1
fd = ipccreat(service);
.P2
To wait for requests, the server uses the
.I ipclisten
routine.  Its argument is the same
.I fd
returned by
.I ipccreat:
.P1
ip = ipclisten(fd);
.P2
.I Ipclisten
returns when some program calls
.I ipcopen
with an argument corresponding to the service, in a way discussed below.
The return value
is a structure containing
information about the caller, such as the user name, and,
where relevant, the name of the machine from which the call was placed.
This new connection may be rejected:
.P1
ipcreject(ip, errcode);
.P2
or it may be accepted:
.P1
fd = ipcaccept(ip, cfd);
.P2
If the server itself is capable of handling all communication with
its client, it passes a null file descriptor as
.I cfd,
and uses the return value of
.I ipcaccept
as a file descriptor to communicate with its client.
Depending on the locations of the server and the client,
this may be either a pipe, or a stream connection to a remote machine.
.PP 
Sometimes, the purpose of a server is not to communicate directly,
but to set up another connection on behalf of its client.
A network dialing server, for example, receives the desired address
in the
.I ip
structure returned by
.I ipclisten,
and connects to this address with network-specific primitives.
If the connection succeeds, the server sends the descriptor
for the connection to the client using the
.I cfd
argument of
.I ipcaccept.
.PP
The various file descriptors in these calls all work properly
with the
.I select
system call, so a single program may issue several
.I ipccreat
calls, and wait for a connection to appear before committing
itself to using
.I ipclisten
on any one of them.
.NH 2
Addresses
.PP
The arguments supplied to
.I ipcopen
and
.I ipccreat
are strings with several components
separated by exclamation mark `!' characters.
The first part is interpreted as a file name.
If it is absolute, it is used as is; otherwise, it is interpreted as
a file in the directory
.CW /cs ,
which we use, conventionally, to collect rendezvous points.
For example, a game controller like that discussed
in a previous section might announce itself with
.P1
ipccreat("mazewar");
.P2
The player program could then connect to the controller with
.P1
ipcopen("mazewar");
.P2
In this simple case, the IPC routines merely accomplish a convenient
packaging of the scheme discussed above.
.PP
When a multi-component argument is given to
.I ipcopen,
the server selected by the first component receives the remaining
components
as part of the
.I ip
structure returned by its
.I ipclisten,
and interprets them according to its own conventions.
For example, there is a dialing server for each kind of network.
If the first component of an
.I ipcopen
specifies a network server,
the remaining components conventionally supply an address
within that network, and possibly a service obtainable at that address.
We have three kinds of networks:
.I tcp
(TCP/IP connection),
.I dk
(Datakit connection), and
.I phone
(dial-up telephone).
Each network server adopts the convention that a missing service name
means a connection to an end-point that allows one to log in by hand.
Therefore, calling
.I ipcopen
with the strings
.P1
tcp!research.att.com
dk!nj/astro/research
phone!201-582-5940
.P2
gets connections over which one will receive a `login:' greeting,
each over a different kind of network.
The servers are responsible for the details of name translation,
performing the appropriate connection protocol, and so forth.
Some examples of named services at particular locations are
.P1
tcp!dutoit.att.com!whoami
dk!research!smtp
.P2
The first is a debugging service that echoes facts about the
connection and the user ID of the person who requests it.
The second illustrates how remote mail is sent;
by connecting to the
.I smtp
server (mail receiver) on the appropriate machine.
.NH 2
IPC Implementation
.PP
For a simple service, the
.I ipccreat
routine works just like the
game-manager program described above; it first creates a file in the
.CW /cs
directory corresponding to the name of the service, then makes
a pipe and stream-mounts one end of the pipe on this file.
For complex services, which have a `!' in their names, the
simple service named to the left of the `!' must be created first;
when
.I ipccreat
is handed the name of such a service, it uses
a version of
.I ipcopen
referring to the simple, underlying server, and passes it the remainder
of the name.
In either case,
.I ipccreat
returns its own end of its pipe, ready to receive requests.
.PP
The
.I ipcopen
routine uses a technique that resembles that used by the
simple network calling routine described above, but differs
in detail.
It opens the file in
.CW /cs
corresponding to the desired service, makes a pipe, and hands
one end of the pipe to the server.  It then sends the actual contents
of the request (the full address) to its end of the pipe,
and waits for an acceptance or rejection message to appear on
this pipe.
.PP
The server
.I ipclisten
call waits for a stream (passed by someone's
.I ipcopen )
to appear on the file descriptor mounted on its
.CW /cs
communication file; as each appears,
it reads the request block from the passed stream,
and returns it to the server.
.PP
After analyzing the request, the server calls either
.I ipcaccept
or
.I ipcreject;
each sends an appropriate message back to the client over the passed
stream.
.I Ipcaccept
has two cases:
when its
.I cfd
argument is empty, the same pipe sent to
the server by the client is used for communication; when
.I cfd
is non-empty,
that file descriptor is sent back to the client.
.I Ipcopen
returns the appropriate descriptor.
.NH 2
Network Managers
.PP
The IPC routines discussed above handle both clients and servers
that are local to a single system, and are also sufficient to accomplish
outgoing network connections.
One missing piece is how to write the programs
that accept connections from a network, and arrange to invoke
the appropriate local services.
We call such programs
.I managers.
.PP
The networking part of a manager is specific to its
network, and usually must conduct dialogues both with the
operating system and with its remote client.
For example, the manager for TCP/IP must arrange
to receive IP packets sent to certain port numbers,
and analyze the packets to determine what service is being
requested;
then it must select a port number for
the conversation, communicate it to the peer, and arrange to collect
packets on this port number.
Finally, the manager must supply the selected local service.
Each network manager could have
.I "ad hoc"
code for this part of the job;
instead, they depend on a more general program called the
.I "service manager.
.NH 2
The Service Manager
.PP
By using
.I ipccreat,
a process establishes itself as a server and prepares to receive requests.
While it is serving, it must remain in existence.
For some servers, like the multi-player game controller that
continues to run as users enter and leave the game,
the longevity of the server is appropriate.
However, many, or even most, useful services do not necessarily
need individual long-lived servers, because the service merely involves
execution of a particular program.
For example, services like
.I rlogin,
.I telnet,
.I smtp
and
.I ftp,
as well as simpler ones that merely provide the
date, or send a file to a line printer, can all
be accomplished merely by running the appropriate program
with input and output connected to the right place.
Even when the characteristics of such services differ
in detail, there are general patterns.
Some, for example, require no authentication, some require checking
of authentication according to an automatic scheme, and others
always insist on a password.
.PP
The observation that many services share a common structure
suggested a common solution: the Service Manager.
It is started when the operating system is booted, and is
driven by a specification file;
each entry in the file
contains the name of the service, and a list of actions
to be performed when that service is requested.
The service manager issues
.I ipccreat
for the name given in each entry; when another process uses
.I ipcopen
to request the service, the service manager carries out each
encoded action.
.PP
The most important action specifies a command to be executed;
for example, the line
.P1 0
date	cmd(date)
.P2
means that connecting to the service
.I date
would run the `date' command.
Other actions may specify the user ID under which the program
is run:
.P1 0
uucp user(uucp)+cmd(/usr/lib/uucp/uucico)
.P2
This service specifies a passwordless connection to the
.I uucp
file-transfer program;
a locally-conventional TCP/IP port
number is used for such connections, and a corresponding convention
is used on our Datakit network.
There are other built-in actions:
.P1 0
login	ttyld+password
.P2
means that the
.I login
service needs to install the line discipline module for terminal
processing, and also to execute the
.I login
command;
.P1 0
oklogin	auth+ttyld+login
.P2
is similar, but allows passwordless login.
Authorization is checked by the
.I auth
specification, which determines whether the call came from a
trusted host on a trusted network, so that the passed user ID
can be believed.
.NH 1
Uses
.PP
The techniques described in this paper permit a general approach
to network and local connections in which most of the work
is done in a few user-mode programs.
As an example of the benefits of the scheme, we have unified
various commands that do remote login over two kinds of networks
(TCP/IP and Datakit).
A single command,
.I con,
tries various networks and uses the first over which a connection
can be made.
The traditional names (like
.I rlogin )
are retained as links, but the only effect of using them is to
influence the order in which networks are tried.
The stream implementation makes the transport layers of the networks
sufficiently similar
that the same code can be used once the connection is established;
the techniques described here make even the connection interface uniform.
.PP
These same techniques extend well to inter-network connectivity.
For example, all our machines have a
Datakit interface, but only a few have Ethernet connections.
Nevertheless, from a Datakit-only machine,
it is easy to connect to another machine that
has only Ethernet, even one that does not run the
Ninth Edition system.
There are two schemes.
In the first,
the local operating system contains the TCP/IP protocol
code, and below the TCP/IP level, the `device' interface is
actually a Datakit connection to another local machine on both networks.
Because Datakit channels and the network layer expected by
TCP/IP have stream interfaces, they are easily connected;
on the gateway machine,
the IP packets are routed appropriately.
This approach transparently handles other services, like UDP,
that use the IP protocol.
.PP
The other scheme uses the methods described in this paper.
On the Datakit-only machine,
the TCP network dialout program does not
use TCP/IP at all, and indeed TCP/IP code need not be configured into
the operating system;
instead, it creates a Datakit transport-level connection
to a protocol-conversion server on a gateway machine.
A complementary server on the gateway accepts TCP/IP
connections on behalf of the Datakit-only machine, and forwards them.
The difference between the two schemes is invisible to
users of connection-oriented protocols, although it does not support
connectionless protocols like UDP.
.NH 1
Conclusion
.PP
Unix has always had a rich file system structure,
both in its naming scheme (hierarchical directories)
and in the properties of open files (disk files, devices, pipes).
The Eighth Edition exploited the file system even more insistently
than its predecessors
or contemporaries of the same genus.
Remote file systems, process files, and the face server
all create objects with names that can
be handed as usefully to an existing tool
as to a new one designed to take advantage of the object's special
properties.
Similarly, the stream I/O system
provides a framework for making file descriptors
act in the standard way most programs already expect,
while providing a richer underlying behavior,
for handling network protocols, or processing appropriate
for terminals.
.PP
The developments described here follow the same path;
they encourage use of the file name space
to establish communication between processes.
In the best of cases,
merely opening a named file is enough.
More complicated situations require more involved negotiations,
but the file system still supplies the point of contact.
Moreover, the necessary negotiations
may be encapsulated in a common form that hides the differences between
local and any of a variety of remote connections.
.NH 1
References
.LP
|reference_placement
