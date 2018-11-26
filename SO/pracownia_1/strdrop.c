int strdrop(char *str, const char *set) {
  char current;
  char *seek = str;
  char *put = str;

  const char *temp;
  char t;

  while ((current = *seek++) != '\0') {
    _Bool copy = 1;
    temp = set;
    while (copy && (t = *temp++) != '\0') {
      if (t == current) {
        copy = 0;
      }
    }
    if (copy) {
      *put++ = current;
    }
  }
  *put = '\0';
  return put - str;
}
