class Extractor {
  static List<String> extract(String str, String key, String separator) {
    int str_n = str.length;
    int key_n = key.length;
    List<String> keyList = [];
    for(int i = 0; i + key_n <= str_n; i++) {
      String substr = str.substring(i, i+key_n);
      if (substr == key) {
        int left = i+key_n;
        while (left < str_n && str[left] != separator) {
          left++;
        }
        int right = left+1;
        while (right < str_n && str[right] != separator) {
          right++;
        }
        if (left<right && right<str_n) {
          keyList.add(str.substring(left+1, right));
          i = right+1;
        }
        else {
          i = i+key_n;
        }

      }
    }
    return keyList;
  }
}