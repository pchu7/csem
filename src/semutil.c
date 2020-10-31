#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semutil.h"
#include "cc.h"
#include "sem.h"
#include "sym.h"

int formalnum;                        /* number of formal arguments    */
struct id_entry* formalvars[MAXLOCS]; /* id_entry array for parameters */
int localnum;                         /* number of local variables     */
struct id_entry* localvars[MAXLOCS];  /* id_entry array for locals     */

extern struct sem_rec **top;
extern void yyerror (const char *msg);

/*
 * dcl - adjust the offset or allocate space for a global
 */
struct id_entry *dcl(struct id_entry *p, int type, int scope)
{
   extern int level;

   p->i_type += type;
   if (scope != 0)
      p->i_scope = scope;
   else if (p->i_width > 0 && level == 2)
      p->i_scope = GLOBAL;
   else
      p->i_scope = LOCAL;

   if (level > 2 && p->i_scope == PARAM) {
      p->i_offset = formalnum;
      formalvars[formalnum++] = p;
      if (formalnum > MAXARGS) {
         fprintf(stderr, "too many arguments\n");
         exit(1);
      }
   }
   else if (level > 2 && p->i_scope != PARAM) {
      p->i_offset = localnum;
      localvars[localnum++] = p;
      if (localnum > MAXLOCS) {
         fprintf(stderr, "too many locals\n");
         exit(1);
      }
   }
   else if (p->i_width > 0 && level == 2) {
      global_alloc(p, p->i_width);
   }
   return p;
}

/*
 * dclr - insert attributes for a declaration
 */
struct id_entry *dclr(const char *name, int type, int width)
{
   struct id_entry *p;
   extern int level;
   char msg[80];

   if ((p = lookup(name, 0)) == NULL || p->i_blevel != level)
      p = install(name, -1);
   else  {
      sprintf(msg, "identifier %s previously declared", name);
      yyerror(msg);
      return (p);
   }
   p->i_defined = 1;
   p->i_type = type;
   p->i_width = width;
   return (p);
}

/*
 * merge - merge backpatch lists p1 and p2
 */
struct sem_rec *merge(struct sem_rec *p1, struct sem_rec *p2)
{
   struct sem_rec *p;

   if (p1 == NULL)
      return (p2);
   if (p2 == NULL)
      return (p1);
   for (p = p1; p->s_link; p = p->s_link)
      ;
   p->s_link = p2;
   return (p1);
}

struct sem_rec *node(void *value, void *bb, int type, struct sem_rec *link,
  struct sem_rec *true_rec, struct sem_rec *false_rec)
{
  struct sem_rec *new_node;

  /* allocate space */
  new_node = (struct sem_rec *) alloc(sizeof(struct sem_rec));

  /* save semantic record */
  save_rec(new_node);

  /* fill in the fields */
  new_node->s_value = value;
  new_node->s_bb    = bb;
  new_node->s_type  = type;
  new_node->s_link  = link;
  new_node->s_true  = true_rec;
  new_node->s_false = false_rec;

  return new_node;
}

struct sem_rec *s_node(void * value, int type)
{
  return (node ( value, (void *) NULL, type,
                  (struct sem_rec *) NULL,
                  (struct sem_rec *) NULL,
                  (struct sem_rec *) NULL ));
}

char *parse_escape_chars(const char *s)
{
  unsigned i, j;
  size_t olen;
  char *p;

  olen = strlen(s);

  i = j = 0;
  p = malloc((sizeof(char)*olen));
  if (!p) {
    fprintf(stderr, "error: out of memory\n");
    exit(1);
  }

  while (i < olen) {
    /* strip off the quotes around the string */
    if (((i==0) || (i==(olen-1))) && (s[i]=='"')) {
      i++;
      continue;
    }

    /* if there's no escape -- just record the character */
    if (s[i] != '\\') {
      p[j++] = s[i++];
      continue;
    }

    /* Handle the escape characters
     * Note that we do not handle hexadecimal or octal sequences
     */
    ++i;
    switch (s[i++]) {
    default:
      fprintf(stderr, "error: invalid escape sequence\n");
      return NULL;

    case 'b':  p[j++] = '\b'; break;
    case 'f':  p[j++] = '\f'; break;
    case 'n':  p[j++] = '\n'; break;
    case 'r':  p[j++] = '\r'; break;
    case 't':  p[j++] = '\t'; break;
    case '"':  p[j++] = '"';  break;
    case '\\': p[j++] = '\\'; break;
    }
  }
  p[j] = '\0';

  p = realloc (p,strlen(p));
  if (!p) {
    fprintf(stderr, "error: resizing memory\n");
    exit(1);
  }

  return p;
}
