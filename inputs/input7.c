#ifdef DEFAULT_CLANG
int print(const char *fmt, ...);
#endif

double m[6];

int main() {
  int i, j;

  i = 0;
  while (i < 6) {
    j = 5;

    do {
      m[i] = m[i] + i*j;
      if ( ((i*j % 3) == 0)) {
        break;
      }
      j = j - 1;
    } while (j > 0);

    i = i+1;
  }

  print("%5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n",
        m[0], m[1], m[2], m[3], m[4], m[5]);
  return 0;
}
