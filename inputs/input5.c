#ifdef DEFAULT_CLANG
int print(const char *fmt, ...);
#endif

double m[6];

int scale(double x) {
  int i;
  
  if (x == 0)
    return 0;
  for (i = 0; i < 6; i += 1)
    m[i] *= x;
  return 1;
}

int main() {
  int i;
  double x;

  i = 0;
  while (i < 6) {
    m[i] = i;
    i = i + 1;
  }

  print("%5.1f %5.1f %5.1f\n", m[0], m[2], m[5]);

  x = 5;
  scale (x);

  print("%5.1f %5.1f %5.1f", m[0], m[2], m[5]);

  return 0;
}
