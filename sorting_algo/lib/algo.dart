void bubbleSort(List<int> table) {
  int len = table.length;
  for (int i = 0; i < len - 1; i++) {
    for (int j = 0; j < len - i - 1; j++) {
      if (table[j] > table[j + 1]) {
        // Swap table[j] and table[j + 1]
        int tmp = table[j];
        table[j] = table[j + 1];
        table[j + 1] = tmp;
      }
    }
  }
}
