#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "string.h"
#include "mail.h"

/* imports */
extern char *mktemp();
extern int sleep();
extern long lseek();

#define FILNAMSIZ 14
#define LOCKPREFIX "/tmp/L."
#define TMPLNAME "/tmp/mlXXXXXX"
static char *UPASROOT = "/usr/lib/upas/";
static char *MAILROOT = "/usr/spool/mail/";
static char *SMTPQROOT = "/usr/spool/smtpq/";
static char *SYSALIAS = "namefiles";
static char *USERALIAS = "/lib/names";
static int MBOXMODE = 0644;
static char lockname[FILNAMSIZ+sizeof("/tmp/")];
static char tlockname[FILNAMSIZ+sizeof("/tmp/")];
static char tmplname[sizeof(TMPLNAME)];

static void lockbotch();

/*
 *  open a file for appending.  if the file doesn't exist, create it.
 *  return the file descriptor.
 */
appendopen(file)
	char *file;
{
	int out;
	long lseek();

	lock(file);
	out = open(file, 2);
	if (out < 0)
		out = creat(file, 0666);
	else
		chmod(file, 0666);
	lseek(out, 0L, 2);
	return out;
}

/*
 *  close an append only file
 */
appendclose(fd)
	int fd;
{
	close(fd);
	unlock();
}

/*
 *  lock and open file.  If the file doesn't exist and mode!=0, create it.
 *  return the file descriptor.
 */

FILE *
lockopen(file, omode, pmode, uid, gid)
	char *file;
	char *omode;
	int pmode;
{
	FILE *fp;
	struct stat sbuf;
	int newfile;

	lock(file);
	if(stat(file, &sbuf)<0)
		newfile = 1;
	else
		newfile = 0;
	fp = fopen(file, omode);
	if(fp==NULL){
		unlock();
		return NULL;
	}
	if(newfile){
		chown(file, uid, gid);
		chmod(file, pmode);
	}
	return fp;
}

/*
 *  close and unlock a file.
 */
lockclose(fp)
	FILE *fp;
{
	fclose(fp);
	unlock();
}

/*
 *  reopen a file without losing the lock.
 */
FILE *
lockreopen(file, omode, fp)
	char *file;
	char *omode;
	FILE *fp;
{
	return freopen(file, omode, fp);
}

/*
 *  remove ALL locks
 */
cleanlocks()
{
	unlock();
}

/* break an old lock */
static void
lockbotch(err, file)
	char *err;
	char *file;
{
	int fd;
	char msg[128];
	char log[256];

	sprintf(msg, "mail: problem with lock file\n");
	write(2, msg, strlen(msg));
	strcpy(log, MAILROOT);
	strcat(log, "mail.log");
	if ((fd=open(log, 1)) >= 0) {
		sprintf(msg, "error %s (tmp=%s lock=%s)\n", err, file, lockname);
		lseek(fd, (long)0, 2);
		write(fd, msg, strlen(msg));
		close(fd);
	}
}

/* Fill name with the lock name for file */
setlname(name, file)
	char *name, *file;
{
	char *slashp;

	(void)strcpy(name, LOCKPREFIX);
	slashp = strrchr(file, '/');
	if (slashp==NULL)
		strncat(name, file, sizeof(lockname)-strlen(name)-1);
	else
		strncat(name, slashp+1, sizeof(lockname)-strlen(name)-1);
	lockname[sizeof(lockname)-1] = '\0';
}

/* Lock the given file */
lock(file)
char *file;
{
	int fd, i;
	char pidbuf[20];

	/* return if we are already in the middle of a lock */
	if (*lockname != '\0') {
		lockbotch("double lock", "");
		return;
	}

	/* create a temporary file */
	(void)strcpy(tmplname, TMPLNAME);
	(void)mktemp(tmplname);
	if ((fd=creat(tmplname, 0444))<0) {
		lockbotch("tmp exists", tmplname);
		return;
	}
	sprintf(pidbuf, "%d upas", getpid());
	write(fd, pidbuf, strlen(pidbuf));
	close(fd);

	/* Make a link to it with the lock file name.  This will fail only
	 * if it already exists.
	 */
	setlname(lockname, file);
	i = 0;
	while (link(tmplname, lockname) < 0) {
		/* File is already locked */
		sleep(2);
		(void) islocked(file); /* might break a stale lock */
		if (++i > 3000) {
			lockbotch("breaking old lock");
			unlink(lockname);
			link(tmplname, lockname);
			break;
		}
	}
	unlink(tmplname);
	*tmplname = '\0';
	return;
}

/* Return true if file has been locked by us or another program using the same
 * lock name scheme.
 * But remove the lock file if the locking process has gone away.
 */
int
islocked(file)
	char *file;
{
	struct stat stbuf;
	int pid;
	FILE *fp;

	setlname(tlockname, file);
	if (stat(tlockname, &stbuf)==0) {
		fp = fopen(tlockname, "r");
		if (fp == NULL || fscanf(fp, "%d", &pid)!=1) {
			/* either we made the lock wrong, or it just went away (race) */
			lockbotch("trouble getting lock pid: breaking lock\n");
			fclose(fp);
			unlink(tlockname);
			return 0;
		}
		fclose(fp);
		if (kill(pid, 0) == 0)
			return 1;
		/* locker has gone away */
		unlink(tlockname);
	}
	return 0;
}

unlock()
{
	if (*tmplname != '\0') {
		unlink(tmplname);
		*tmplname = '\0';
	}
	if (*lockname != '\0') {
		unlink(lockname);
		*lockname = '\0';
	}
}
