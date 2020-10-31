#ifndef SEM_H
#define SEM_H

void
global_alloc (struct id_entry*, int);

void
backpatch(struct sem_rec *, int);

struct sem_rec*
call(char *, struct sem_rec *);

struct sem_rec*
cast(struct sem_rec *, int);

struct sem_rec*
ccand(struct sem_rec *e1, void *m, struct sem_rec *e2);

struct sem_rec*
ccexpr(struct sem_rec *);

struct sem_rec*
ccnot(struct sem_rec *);

struct sem_rec*
ccor(struct sem_rec *e1, void *m, struct sem_rec *e2);

struct sem_rec*
con(const char *);

void
dobreak();

void
docontinue();

void
dodo(void *m1, void *m2, struct sem_rec *cond, void *m3);

void
dofor(void *m1, struct sem_rec *cond, void *m2, struct sem_rec *n1, void *m3,
  struct sem_rec *n2, void *m4);

void
dogoto(char *);

void
doif(struct sem_rec *cond, void *m1, void *m2);

void
doifelse(struct sem_rec *cond, void *m1, struct sem_rec *n,
  void *m2, void *m3);

void
doret(struct sem_rec *);

void
dowhile(void *m1, struct sem_rec *cond, void *m2,
  struct sem_rec *n, void *m3);

void
endloopscope();

struct sem_rec*
exprs(struct sem_rec *, struct sem_rec *);

void
fhead(struct id_entry *);

struct id_entry*
fname(int, char *);

void
ftail();

struct sem_rec*
gen(char *, struct sem_rec *, struct sem_rec *, int);

struct sem_rec*
id(char *);

struct sem_rec*
indx(struct sem_rec *x, struct sem_rec *i);

void*
m();

struct sem_rec*
n();

void
labeldcl(const char *);

struct sem_rec*
op1(const char *, struct sem_rec *);

struct sem_rec*
op2(const char *, struct sem_rec *, struct sem_rec *);

struct sem_rec*
opb(const char *, struct sem_rec *, struct sem_rec *);

struct sem_rec*
rel(const char *, struct sem_rec *, struct sem_rec *);

struct sem_rec*
set(const char *, struct sem_rec *, struct sem_rec *);

void
startloopscope();

struct sem_rec*
genstring(char *);

void
init_IR ();

void
emit_IR ();

#endif

