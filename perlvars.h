/*    perlvars.h
 *
 *    Copyright (c) 1997-2002, Larry Wall
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 */

/****************/
/* Truly global */
/****************/

/* Don't forget to re-run embed.pl to propagate changes! */

/* This file describes the "global" variables used by perl
 * This used to be in perl.h directly but we want to abstract out into
 * distinct files which are per-thread, per-interpreter or really global,
 * and how they're initialized.
 *
 * The 'G' prefix is only needed for vars that need appropriate #defines
 * generated in embed*.h.  Such symbols are also used to generate
 * the appropriate export list for win32. */

/* global state */
PERLVAR(Gcurinterp,	PerlInterpreter *)
					/* currently running interpreter
					 * (initial parent interpreter under
					 * useithreads) */
#if defined(USE_5005THREADS) || defined(USE_ITHREADS)
PERLVAR(Gthr_key,	perl_key)	/* key to retrieve per-thread struct */
#endif

/* constants (these are not literals to facilitate pointer comparisons) */
PERLVARIC(GYes,		char *, "1")
PERLVARIC(GNo,		char *, "")
PERLVARIC(Ghexdigit,	char *, "0123456789abcdef0123456789ABCDEF")
PERLVARIC(Gpatleave,	char *, "\\.^$@dDwWsSbB+*?|()-nrtfeaxc0123456789[{]}")

/* XXX does anyone even use this? */
PERLVARI(Gdo_undump,	bool,	FALSE)	/* -u or dump seen? */

#if defined(MYMALLOC) && (defined(USE_5005THREADS) || defined(USE_ITHREADS))
PERLVAR(Gmalloc_mutex,	perl_mutex)	/* Mutex for malloc */
#endif

#if defined(USE_ITHREADS)
PERLVAR(Gop_mutex,	perl_mutex)	/* Mutex for op refcounting */
#endif

/* Force inclusion of both runops options */
PERLVARI(Grunops_std,	runops_proc_t,	MEMBER_TO_FPTR(Perl_runops_standard))
PERLVARI(Grunops_dbg,	runops_proc_t,	MEMBER_TO_FPTR(Perl_runops_debug))

/* Hooks to shared SVs and locks. */
PERLVARI(Gsharehook,	share_proc_t,	MEMBER_TO_FPTR(Perl_sv_nosharing))
PERLVARI(Glockhook,	share_proc_t,	MEMBER_TO_FPTR(Perl_sv_nolocking))
PERLVARI(Gunlockhook,	share_proc_t,	MEMBER_TO_FPTR(Perl_sv_nounlocking))
PERLVARI(Gthreadhook,	thrhook_proc_t,	MEMBER_TO_FPTR(Perl_nothreadhook))

/* Stores the PPID */
#ifdef THREADS_HAVE_PIDS
PERLVARI(Gppid,		IV,		0)
#endif
