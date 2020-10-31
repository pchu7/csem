#ifdef DEFAULT_CLANG
int print(const char *fmt, ...);
#endif

double m[6];

int main() {
  int i;

  i = 0;
  while (i < 6) {
    if (i < 2) {
      i = i + 1;
      continue;
    }
    m[i] = i;
    i = i + 1;
    if (i > 4) {
      break;
    }
  }

  print("%5.1f %5.1f %5.1f\n", m[0], m[2], m[5]);
  return 0;
}
