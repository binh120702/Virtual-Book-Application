class Extractor {
  static List<String> extract(String str, String key, String separator) {
    int strN = str.length;
    int keyN = key.length;
    List<String> keyList = [];
    for(int i = 0; i + keyN <= strN; i++) {
      String substr = str.substring(i, i+keyN);
      if (substr == key) {
        int left = i+keyN;
        while (left < strN && str[left] != separator) {
          left++;
        }
        int right = left+1;
        while (right < strN && str[right] != separator) {
          right++;
        }
        if (left<right && right<strN) {
          keyList.add(str.substring(left+1, right));
          i = right+1;
        }
        else {
          i = i+keyN;
        }

      }
    }
    return keyList;
  }
}