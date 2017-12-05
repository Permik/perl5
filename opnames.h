/* -*- buffer-read-only: t -*-
 *
 *    opnames.h
 *
 *    Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007,
 *    2008 by Larry Wall and others
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 * This file is built by regen/opcode.pl from its data.
 * Any changes made here will be lost!
 */

typedef enum opcode {
	OP_NULL		 = 0,
	OP_STUB		 = 1,
	OP_SCALAR	 = 2,
	OP_PUSHMARK	 = 3,
	OP_WANTARRAY	 = 4,
	OP_CONST	 = 5,
	OP_GVSV		 = 6,
	OP_GV		 = 7,
	OP_GELEM	 = 8,
	OP_PADSV	 = 9,
	OP_PADAV	 = 10,
	OP_PADHV	 = 11,
	OP_PADANY	 = 12,
	OP_RV2GV	 = 13,
	OP_RV2SV	 = 14,
	OP_AV2ARYLEN	 = 15,
	OP_RV2CV	 = 16,
	OP_ANONCODE	 = 17,
	OP_PROTOTYPE	 = 18,
	OP_REFGEN	 = 19,
	OP_SREFGEN	 = 20,
	OP_REF		 = 21,
	OP_BLESS	 = 22,
	OP_BACKTICK	 = 23,
	OP_GLOB		 = 24,
	OP_READLINE	 = 25,
	OP_RCATLINE	 = 26,
	OP_REGCMAYBE	 = 27,
	OP_REGCRESET	 = 28,
	OP_REGCOMP	 = 29,
	OP_MATCH	 = 30,
	OP_QR		 = 31,
	OP_SUBST	 = 32,
	OP_SUBSTCONT	 = 33,
	OP_TRANS	 = 34,
	OP_TRANSR	 = 35,
	OP_SASSIGN	 = 36,
	OP_AASSIGN	 = 37,
	OP_CHOP		 = 38,
	OP_SCHOP	 = 39,
	OP_CHOMP	 = 40,
	OP_SCHOMP	 = 41,
	OP_DEFINED	 = 42,
	OP_UNDEF	 = 43,
	OP_STUDY	 = 44,
	OP_POS		 = 45,
	OP_PREINC	 = 46,
	OP_I_PREINC	 = 47,
	OP_PREDEC	 = 48,
	OP_I_PREDEC	 = 49,
	OP_POSTINC	 = 50,
	OP_I_POSTINC	 = 51,
	OP_POSTDEC	 = 52,
	OP_I_POSTDEC	 = 53,
	OP_POW		 = 54,
	OP_MULTIPLY	 = 55,
	OP_I_MULTIPLY	 = 56,
	OP_DIVIDE	 = 57,
	OP_I_DIVIDE	 = 58,
	OP_MODULO	 = 59,
	OP_I_MODULO	 = 60,
	OP_REPEAT	 = 61,
	OP_ADD		 = 62,
	OP_I_ADD	 = 63,
	OP_SUBTRACT	 = 64,
	OP_I_SUBTRACT	 = 65,
	OP_CONCAT	 = 66,
	OP_MULTICONCAT	 = 67,
	OP_STRINGIFY	 = 68,
	OP_LEFT_SHIFT	 = 69,
	OP_RIGHT_SHIFT	 = 70,
	OP_LT		 = 71,
	OP_I_LT		 = 72,
	OP_GT		 = 73,
	OP_I_GT		 = 74,
	OP_LE		 = 75,
	OP_I_LE		 = 76,
	OP_GE		 = 77,
	OP_I_GE		 = 78,
	OP_EQ		 = 79,
	OP_I_EQ		 = 80,
	OP_NE		 = 81,
	OP_I_NE		 = 82,
	OP_NCMP		 = 83,
	OP_I_NCMP	 = 84,
	OP_SLT		 = 85,
	OP_SGT		 = 86,
	OP_SLE		 = 87,
	OP_SGE		 = 88,
	OP_SEQ		 = 89,
	OP_SNE		 = 90,
	OP_SCMP		 = 91,
	OP_BIT_AND	 = 92,
	OP_BIT_XOR	 = 93,
	OP_BIT_OR	 = 94,
	OP_NBIT_AND	 = 95,
	OP_NBIT_XOR	 = 96,
	OP_NBIT_OR	 = 97,
	OP_SBIT_AND	 = 98,
	OP_SBIT_XOR	 = 99,
	OP_SBIT_OR	 = 100,
	OP_NEGATE	 = 101,
	OP_I_NEGATE	 = 102,
	OP_NOT		 = 103,
	OP_COMPLEMENT	 = 104,
	OP_NCOMPLEMENT	 = 105,
	OP_SCOMPLEMENT	 = 106,
	OP_SMARTMATCH	 = 107,
	OP_ATAN2	 = 108,
	OP_SIN		 = 109,
	OP_COS		 = 110,
	OP_RAND		 = 111,
	OP_SRAND	 = 112,
	OP_EXP		 = 113,
	OP_LOG		 = 114,
	OP_SQRT		 = 115,
	OP_INT		 = 116,
	OP_HEX		 = 117,
	OP_OCT		 = 118,
	OP_ABS		 = 119,
	OP_LENGTH	 = 120,
	OP_SUBSTR	 = 121,
	OP_VEC		 = 122,
	OP_INDEX	 = 123,
	OP_RINDEX	 = 124,
	OP_SPRINTF	 = 125,
	OP_FORMLINE	 = 126,
	OP_ORD		 = 127,
	OP_CHR		 = 128,
	OP_CRYPT	 = 129,
	OP_UCFIRST	 = 130,
	OP_LCFIRST	 = 131,
	OP_UC		 = 132,
	OP_LC		 = 133,
	OP_QUOTEMETA	 = 134,
	OP_RV2AV	 = 135,
	OP_AELEMFAST	 = 136,
	OP_AELEMFAST_LEX = 137,
	OP_AELEM	 = 138,
	OP_ASLICE	 = 139,
	OP_KVASLICE	 = 140,
	OP_AEACH	 = 141,
	OP_AVALUES	 = 142,
	OP_AKEYS	 = 143,
	OP_EACH		 = 144,
	OP_VALUES	 = 145,
	OP_KEYS		 = 146,
	OP_DELETE	 = 147,
	OP_EXISTS	 = 148,
	OP_RV2HV	 = 149,
	OP_HELEM	 = 150,
	OP_HSLICE	 = 151,
	OP_KVHSLICE	 = 152,
	OP_MULTIDEREF	 = 153,
	OP_UNPACK	 = 154,
	OP_PACK		 = 155,
	OP_SPLIT	 = 156,
	OP_JOIN		 = 157,
	OP_LIST		 = 158,
	OP_LSLICE	 = 159,
	OP_ANONLIST	 = 160,
	OP_ANONHASH	 = 161,
	OP_SPLICE	 = 162,
	OP_PUSH		 = 163,
	OP_POP		 = 164,
	OP_SHIFT	 = 165,
	OP_UNSHIFT	 = 166,
	OP_SORT		 = 167,
	OP_REVERSE	 = 168,
	OP_GREPSTART	 = 169,
	OP_GREPWHILE	 = 170,
	OP_MAPSTART	 = 171,
	OP_MAPWHILE	 = 172,
	OP_RANGE	 = 173,
	OP_FLIP		 = 174,
	OP_FLOP		 = 175,
	OP_AND		 = 176,
	OP_OR		 = 177,
	OP_XOR		 = 178,
	OP_DOR		 = 179,
	OP_COND_EXPR	 = 180,
	OP_ANDASSIGN	 = 181,
	OP_ORASSIGN	 = 182,
	OP_DORASSIGN	 = 183,
	OP_ENTERSUB	 = 184,
	OP_LEAVESUB	 = 185,
	OP_LEAVESUBLV	 = 186,
	OP_ARGCHECK	 = 187,
	OP_ARGELEM	 = 188,
	OP_ARGDEFELEM	 = 189,
	OP_CALLER	 = 190,
	OP_WARN		 = 191,
	OP_DIE		 = 192,
	OP_RESET	 = 193,
	OP_LINESEQ	 = 194,
	OP_NEXTSTATE	 = 195,
	OP_DBSTATE	 = 196,
	OP_UNSTACK	 = 197,
	OP_ENTER	 = 198,
	OP_LEAVE	 = 199,
	OP_SCOPE	 = 200,
	OP_ENTERITER	 = 201,
	OP_ITER		 = 202,
	OP_ENTERLOOP	 = 203,
	OP_LEAVELOOP	 = 204,
	OP_RETURN	 = 205,
	OP_LAST		 = 206,
	OP_NEXT		 = 207,
	OP_REDO		 = 208,
	OP_DUMP		 = 209,
	OP_GOTO		 = 210,
	OP_EXIT		 = 211,
	OP_METHOD	 = 212,
	OP_METHOD_NAMED	 = 213,
	OP_METHOD_SUPER	 = 214,
	OP_METHOD_REDIR	 = 215,
	OP_METHOD_REDIR_SUPER = 216,
	OP_ENTERGIVEN	 = 217,
	OP_ENTERWHEN	 = 218,
	OP_LEAVEWHEN	 = 219,
	OP_CONTINUE	 = 220,
	OP_OPEN		 = 221,
	OP_CLOSE	 = 222,
	OP_PIPE_OP	 = 223,
	OP_FILENO	 = 224,
	OP_UMASK	 = 225,
	OP_BINMODE	 = 226,
	OP_TIE		 = 227,
	OP_UNTIE	 = 228,
	OP_TIED		 = 229,
	OP_DBMOPEN	 = 230,
	OP_DBMCLOSE	 = 231,
	OP_SSELECT	 = 232,
	OP_SELECT	 = 233,
	OP_GETC		 = 234,
	OP_READ		 = 235,
	OP_ENTERWRITE	 = 236,
	OP_LEAVEWRITE	 = 237,
	OP_PRTF		 = 238,
	OP_PRINT	 = 239,
	OP_SAY		 = 240,
	OP_SYSOPEN	 = 241,
	OP_SYSSEEK	 = 242,
	OP_SYSREAD	 = 243,
	OP_SYSWRITE	 = 244,
	OP_EOF		 = 245,
	OP_TELL		 = 246,
	OP_SEEK		 = 247,
	OP_TRUNCATE	 = 248,
	OP_FCNTL	 = 249,
	OP_IOCTL	 = 250,
	OP_FLOCK	 = 251,
	OP_SEND		 = 252,
	OP_RECV		 = 253,
	OP_SOCKET	 = 254,
	OP_SOCKPAIR	 = 255,
	OP_BIND		 = 256,
	OP_CONNECT	 = 257,
	OP_LISTEN	 = 258,
	OP_ACCEPT	 = 259,
	OP_SHUTDOWN	 = 260,
	OP_GSOCKOPT	 = 261,
	OP_SSOCKOPT	 = 262,
	OP_GETSOCKNAME	 = 263,
	OP_GETPEERNAME	 = 264,
	OP_LSTAT	 = 265,
	OP_STAT		 = 266,
	OP_FTRREAD	 = 267,
	OP_FTRWRITE	 = 268,
	OP_FTREXEC	 = 269,
	OP_FTEREAD	 = 270,
	OP_FTEWRITE	 = 271,
	OP_FTEEXEC	 = 272,
	OP_FTIS		 = 273,
	OP_FTSIZE	 = 274,
	OP_FTMTIME	 = 275,
	OP_FTATIME	 = 276,
	OP_FTCTIME	 = 277,
	OP_FTROWNED	 = 278,
	OP_FTEOWNED	 = 279,
	OP_FTZERO	 = 280,
	OP_FTSOCK	 = 281,
	OP_FTCHR	 = 282,
	OP_FTBLK	 = 283,
	OP_FTFILE	 = 284,
	OP_FTDIR	 = 285,
	OP_FTPIPE	 = 286,
	OP_FTSUID	 = 287,
	OP_FTSGID	 = 288,
	OP_FTSVTX	 = 289,
	OP_FTLINK	 = 290,
	OP_FTTTY	 = 291,
	OP_FTTEXT	 = 292,
	OP_FTBINARY	 = 293,
	OP_CHDIR	 = 294,
	OP_CHOWN	 = 295,
	OP_CHROOT	 = 296,
	OP_UNLINK	 = 297,
	OP_CHMOD	 = 298,
	OP_UTIME	 = 299,
	OP_RENAME	 = 300,
	OP_LINK		 = 301,
	OP_SYMLINK	 = 302,
	OP_READLINK	 = 303,
	OP_MKDIR	 = 304,
	OP_RMDIR	 = 305,
	OP_OPEN_DIR	 = 306,
	OP_READDIR	 = 307,
	OP_TELLDIR	 = 308,
	OP_SEEKDIR	 = 309,
	OP_REWINDDIR	 = 310,
	OP_CLOSEDIR	 = 311,
	OP_FORK		 = 312,
	OP_WAIT		 = 313,
	OP_WAITPID	 = 314,
	OP_SYSTEM	 = 315,
	OP_EXEC		 = 316,
	OP_KILL		 = 317,
	OP_GETPPID	 = 318,
	OP_GETPGRP	 = 319,
	OP_SETPGRP	 = 320,
	OP_GETPRIORITY	 = 321,
	OP_SETPRIORITY	 = 322,
	OP_TIME		 = 323,
	OP_TMS		 = 324,
	OP_LOCALTIME	 = 325,
	OP_GMTIME	 = 326,
	OP_ALARM	 = 327,
	OP_SLEEP	 = 328,
	OP_SHMGET	 = 329,
	OP_SHMCTL	 = 330,
	OP_SHMREAD	 = 331,
	OP_SHMWRITE	 = 332,
	OP_MSGGET	 = 333,
	OP_MSGCTL	 = 334,
	OP_MSGSND	 = 335,
	OP_MSGRCV	 = 336,
	OP_SEMOP	 = 337,
	OP_SEMGET	 = 338,
	OP_SEMCTL	 = 339,
	OP_REQUIRE	 = 340,
	OP_DOFILE	 = 341,
	OP_HINTSEVAL	 = 342,
	OP_ENTEREVAL	 = 343,
	OP_LEAVEEVAL	 = 344,
	OP_ENTERTRY	 = 345,
	OP_LEAVETRY	 = 346,
	OP_GHBYNAME	 = 347,
	OP_GHBYADDR	 = 348,
	OP_GHOSTENT	 = 349,
	OP_GNBYNAME	 = 350,
	OP_GNBYADDR	 = 351,
	OP_GNETENT	 = 352,
	OP_GPBYNAME	 = 353,
	OP_GPBYNUMBER	 = 354,
	OP_GPROTOENT	 = 355,
	OP_GSBYNAME	 = 356,
	OP_GSBYPORT	 = 357,
	OP_GSERVENT	 = 358,
	OP_SHOSTENT	 = 359,
	OP_SNETENT	 = 360,
	OP_SPROTOENT	 = 361,
	OP_SSERVENT	 = 362,
	OP_EHOSTENT	 = 363,
	OP_ENETENT	 = 364,
	OP_EPROTOENT	 = 365,
	OP_ESERVENT	 = 366,
	OP_GPWNAM	 = 367,
	OP_GPWUID	 = 368,
	OP_GPWENT	 = 369,
	OP_SPWENT	 = 370,
	OP_EPWENT	 = 371,
	OP_GGRNAM	 = 372,
	OP_GGRGID	 = 373,
	OP_GGRENT	 = 374,
	OP_SGRENT	 = 375,
	OP_EGRENT	 = 376,
	OP_GETLOGIN	 = 377,
	OP_SYSCALL	 = 378,
	OP_LOCK		 = 379,
	OP_ONCE		 = 380,
	OP_CUSTOM	 = 381,
	OP_COREARGS	 = 382,
	OP_AVHVSWITCH	 = 383,
	OP_RUNCV	 = 384,
	OP_FC		 = 385,
	OP_PADCV	 = 386,
	OP_INTROCV	 = 387,
	OP_CLONECV	 = 388,
	OP_PADRANGE	 = 389,
	OP_REFASSIGN	 = 390,
	OP_LVREF	 = 391,
	OP_LVREFSLICE	 = 392,
	OP_LVAVREF	 = 393,
	OP_ANONCONST	 = 394,
	OP_max		
} opcode;

#define MAXO 395
#define OP_FREED MAXO

/* the OP_IS_* macros are optimized to a simple range check because
    all the member OPs are contiguous in regen/opcodes table.
    opcode.pl verifies the range contiguity, or generates an OR-equals
    expression */

#define OP_IS_SOCKET(op)	\
	((op) >= OP_SEND && (op) <= OP_GETPEERNAME)

#define OP_IS_FILETEST(op)	\
	((op) >= OP_FTRREAD && (op) <= OP_FTBINARY)

#define OP_IS_FILETEST_ACCESS(op)	\
	((op) >= OP_FTRREAD && (op) <= OP_FTEEXEC)

#define OP_IS_NUMCOMPARE(op)	\
	((op) >= OP_LT && (op) <= OP_I_NCMP)

#define OP_IS_DIRHOP(op)	\
	((op) >= OP_READDIR && (op) <= OP_CLOSEDIR)

#define OP_IS_INFIX_BIT(op)	\
	((op) >= OP_BIT_AND && (op) <= OP_SBIT_OR)

/* ex: set ro: */
