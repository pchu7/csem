#ifdef DEFAULT_CLANG
int print(const char *fmt, ...);
#endif

double m[6];

int main() {
  int i, j;

  i = 1;
  j = 8;

L1:
  m[i] = m[i] + i*j;
  if ( (m[i] > 30)) {
    goto L0;
  }
  j = j-1;
  goto L1;

L0:
  i = i+1;
  if (i < 4) {
    j = 8;
    goto L1;
  }

  print("%5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n",
        m[0], m[1], m[2], m[3], m[4], m[5]);
  return 0;
}
