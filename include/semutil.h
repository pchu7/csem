#ifndef SEMUTIL_H
#define SEMUTIL_H

#define MAXARGS 50
#define MAXLOCS 50

struct id_entry*
dcl(struct id_entry *, int, int);

struct id_entry*
dclr(const char *, int, int);

struct sem_rec*
merge(struct sem_rec *, struct sem_rec *);

struct sem_rec *
node(void *value, void *bb, int type, struct sem_rec *link,
  struct sem_rec *true_rec, struct sem_rec *false_rec);

struct sem_rec *
s_node(void * value, int type);

char *
parse_escape_chars(const char *);

#endif
