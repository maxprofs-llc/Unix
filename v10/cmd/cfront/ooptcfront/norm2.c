/*ident	"@(#)ctrans:src/norm2.c	1.1.5.6" */
/************************************************************************

	C++ source for cfront, the C++ compiler front-end
	written in the computer science research center of Bell Labs

	Copyright (c) 1984 AT&T, Inc. All rigths Reserved
	THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF AT&T, INC.

norm2.c:

	"normalization" handles problems which could have been handled
	by the syntax analyser; but has not been done. The idea is
	to simplify the grammar and the actions associated with it,
	and to get a more robust error handling

****************************************************************************/

#include "cfront.h"
#include "size.h"
const NBITE = (CHUNK-8)/sizeof(name)-1;
const EBITE = (CHUNK-8)/sizeof(expr)-1;
const SBITE = (CHUNK-8)/sizeof(stmt)-1;

fct::fct(Ptype t, Pname arg, TOK known)
{
	base = FCT;
	nargs_known = known;
	returns = t;
	argtype = arg; 

	if (arg==0 || arg->base==ELIST) return;
//error('d',"fct::fct %d sig %d",this,f_signature);
	register Pname n;
	Pname pn = 0;
	for (n=arg; n; pn=n,n=n->n_list) {
		switch (n->tp->base) {
		case VOID:
			argtype = 0;
			nargs_known = 1;
			if (n->string)
				error("voidFA%n",n);
			else if (nargs || n->n_list) {
				error("voidFA");
				nargs_known = 0;
			}
			nargs = 0;
			break;
		case CLASS:
		case ENUM:
			error("%k defined inAL (will not be in scope at point of call)",n->tp->base);
			if (n == argtype)
				argtype = n->n_list;
			else
				pn->n_list = n->n_list;
			break;
		default:
			nargs++;
		}
	}
}

expr::expr(TOK ba, Pexpr a, Pexpr b)
{
	base = ba;
	e1 = a;
	e2 = b;
}


stmt::stmt(TOK ba, loc ll, Pstmt a)
{
//	Ns++;
	base = ba;
	where = ll;
	s=a;
}

classdef::classdef(TOK b)
{
	base = CLASS;
	csu = b;
	memtbl = new table(CTBLSIZE,0,0);
}

basetype::basetype(TOK b, Pname n)
{
//	Nbt++;
	switch (b) {
	case 0:				break;
	case TYPEDEF:	b_typedef = 1;	break;
	case INLINE:	b_inline = 1;	break;
	case VIRTUAL:	b_virtual = 1;	break;
	case CONST:	b_const = 1;	break;
	case UNSIGNED:	b_unsigned = 1;	break;
	case FRIEND:
	case OVERLOAD:
	case EXTERN:
	case STATIC:
	case AUTO:
	case REGISTER:	b_sto = b;	break;
	case SHORT:	b_short = 1;	break;
	case LONG:	b_long = 1;	break;
	case ANY:
	case ZTYPE:
	case VOID:
	case CHAR:
	case INT:
	case FLOAT:
	case LDOUBLE:
	case DOUBLE:	base = b; 	break;
	case TYPE:
	case COBJ:
	case EOBJ:
	case FIELD:
	case ASM:
		base = b;
		b_name = n;
		break;
	case SIGNED:
	case VOLATILE:
		error('w',"\"%k\" not implemented (ignored)",b);
		break;
	default:
		error('i',"badBT:%k",b);
	}
}

name::name(char* s) : (NAME,0,0)
{
	string = s;
	where = curloc;
	lex_level = bl_level;

}

nlist::nlist(Pname n)
{
	head = n;
	for (Pname nn=n; nn->n_list; nn=nn->n_list);
	tail = nn;
}

void nlist::add_list(Pname n)
{
	if (n->tp && (n->tp->defined & IN_ERROR)) return;

	tail->n_list = n;
	for (Pname nn=n; nn->n_list; nn=nn->n_list);
	tail = nn;
}

Pname name_unlist(Pnlist l)
{
	if (l == 0) return 0;
	Pname n = l->head;

	delete l;
	return n;
}

Pstmt stmt_unlist(Pslist l)
{
	if (l == 0) return 0;
	Pstmt s = l->head;
//	NFl++;

	delete l;
	return s;
}

Pexpr expr_unlist(Pelist l)
{
	if (l == 0) return 0;
	Pexpr e = l->head;
//	NFl++;

	delete l;
	return e;
}

void sig_name(Pname n)
{
	static char buf[256];
	buf[0] = '_';
	buf[1] = '_';
	buf[2] = 'o';
	buf[3] = 'p';
	char* p = n->tp->signature(buf+4);
	if (255 < p-buf) error('i',"sig_name():N buffer overflow");
	n->string = buf;
	n->tp = 0;
}

Ptype tok_to_type(TOK b)
{
	Ptype t;
	switch (b) {
	case CHAR:	t = char_type; break;
	case SHORT:	t = short_type; break;
	case LONG:	t = long_type; break;
	case UNSIGNED:	t = uint_type; break;
	case FLOAT:	t = float_type; break;
	case DOUBLE:	t = double_type; break;
	case LDOUBLE:	t = ldouble_type; break;
	case VOID:	t = void_type; break;
	default:	error("illegalK:%k",b);
	case INT:	t = int_type;
	}
	return t;
}

Pbase defa_type;
Pbase moe_type;
Pexpr dummy;
Pexpr zero;

Pclass ccl;
Plist modified_tn = 0;

// local class
Plist local_tn = 0;
Plist local_blk = 0;
Plist local_class = 0;

static name sta_name_dummy;
Pname sta_name = &sta_name_dummy;

TOK back;

void memptrdcl(Pname bn, Pname tn, Ptype ft, Pname n)
{
	Pptr p = new ptr(PTR,0);
	p->memof = Pclass(Pbase(bn->tp)->b_name->tp);
	Pbase b = new basetype(TYPE,tn);
	PERM(p);
	Pfct f = Pfct(ft);
	Ptype t = n->tp;
	if (t) {
		p->typ = t;
	ltlt:
		switch (t->base) {
		case PTR:
		case RPTR:
		case VEC:
			if (Pptr(t)->typ == 0) {
				Pptr(t)->typ = b;
				break;
			}
			t = Pptr(t)->typ;
			goto ltlt;
		default:
			error('s',"P toMFT too complicated");
		}
	}
	else
	p->typ = b;	
	f->returns = p;
	n->tp = f;
}
/* ODI notes -

   remove constructors that have been replaces by new and delete
   operators
*/
