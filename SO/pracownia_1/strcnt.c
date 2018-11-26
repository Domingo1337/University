int strcnt(const char *str, const char *set) {
  int count = 0;
  char current;

  const char *temp;
  char t;

  while ((current = *str++) != '\0') {
    temp = set;
    while ((t = *temp++) != '\0') {
      if (t == current) {
        count++;
        break;
      }
    }
  }
  return count;
}
