#ifndef CC_H
#define CC_H

void yyerror (const char *msg);

/* symbol table entry */
struct id_entry {
   void *i_value;
   struct id_entry *i_link;	/* pointer to next entry on hash chain */
   const char *i_name;		/* pointer to name in string table */
   int i_type;			/* type code */
   int i_blevel;		/* block level */
   int i_defined;		/* non-zero if identifier is declared */
   int i_width;			/* number of words occupied */
   int i_scope;			/* scope */
   int i_offset;		/* offset in activation frame */
};

/* scopes *** do not rearrange *** */
#define LOCAL 0
#define PARAM 1
#define GLOBAL 2

/* internal types *** do not rearrange *** */
#define T_INT	   (1<<0)	  /* integer */
#define T_STR    (1<<1)		/* string */
#define T_DOUBLE (1<<2)		/* double */
#define T_PROC   (1<<3)		/* procedure */
#define T_ARRAY  (1<<4)		/* array */
#define T_ADDR   (1<<5)		/* address */
#define T_LBL    (1<<6)		/* label */

/* semantic record */
struct sem_rec {
  void *s_value;            /* for referring to results of instructions */
  void *s_bb;               /* for identifying temporary labels */

  int s_type;               /* type of expression or identifier */
  struct sem_rec *s_link;	  /* used to link sem_recs for backpatching */
  struct sem_rec *s_true;	  /* true backpatch list */
  struct sem_rec *s_false;	/* false backpatch list */
};

#endif
