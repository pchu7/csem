#ifdef DEFAULT_CLANG
int print(const char *fmt, ...);
#endif

int main()
{
  int a, c;
  double b, d;

  a = 3;
  b = 4;
  c = 5;
  d = 6;

  if ( a<b && c<d && d>a || a==b ) {
    print("whoa\n");
  } else {
    print("what\n");
  }
  return 0;
}
