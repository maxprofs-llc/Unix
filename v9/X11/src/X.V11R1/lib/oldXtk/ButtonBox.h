/* $Header: ButtonBox.h,v 1.1 87/09/11 07:58:55 toddb Exp $ */
/*
 *	sccsid:	%W%	%G%
 */

/*
 * Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts.
 *
 *                         All Rights Reserved
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and that
 * both that copyright notice and this permission notice appear in
 * supporting documentation, and that the name of Digital Equipment
 * Corporation not be used in advertising or publicity pertaining to
 * distribution of the software without specific, written prior permission.
 *
 *
 * DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
 * ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
 * DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
 * ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 */

#ifndef _XtButtonBox_h
#define _XtButtonBox_h

/***********************************************************************
 *
 * Button Box Widget
 *
 ***********************************************************************/

#define XtNwindow		"window"
#define XtNx			"x"
#define XtNy			"y"
#define XtNwidth		"width"
#define XtNheight		"height"
#define XtNborderWidth		"borderWidth"
#define XtNborder		"border"
#define XtNbackground		"background"
#define XtNhSpace		"hSpace"
#define XtNvSpace		"vSpace"
#define XtNindex		"index"
#define XtNbutton		"button"
#define XtNresizable		"resizable"

extern Window XtButtonBoxCreate(); /* parentWindow, args, argCount */
    /* Window   parentWindow;   */
    /* ArgList  args;        */
    /* int      argCount;       */

/*

 Parameters
 ==========

 Name		Class		RepType		Default Value
 ----		-----		-------		-------------
 window		Window		Window		NONE, required parameter
 index		Int		int		0

*/

extern XtStatus XtButtonBoxAddButton(); /* dpy, parent, args, argCount */
    /* Display  *dpy; */
    /* Window   parent;     */
    /* ArgList  args;    */
    /* int      argCount;   */

/*

 Parameters
 ==========

 Name		Class		RepType		Default Value
 ----		-----		-------		-------------
 window		Window		Window		computed from index (*)
 index		Int		int		computed from window (*)

* - one of Window or Index is required.

*/

extern XtStatus XtButtonBoxDeleteButton(); /* dpy, parent, args, argCount */
    /* Display	*dpy */
    /* Window   parent;     */
    /* ArgList  args;    */
    /* int      argCount;   */

extern void XtButtonBoxGetValues (); /* dpy, window, args, argCount */
    /* Display *dpy; */
    /* Window window; */
    /* ArgList args; */
    /* int argCount; */

extern void XtButtonBoxSetValues (); /* dpy, window, args, argCount */
    /* Display *dpy; */
    /* Window window; */
    /* ArgList args; */
    /* int argCount; */

#endif _XtButtonBox_h
/* DON'T ADD STUFF AFTER THIS #endif */