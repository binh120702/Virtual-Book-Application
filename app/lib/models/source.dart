import 'book.dart';

abstract class Source {
  late Book myBook;
  late List<String> chapNameList;
  late List<String> chapUrlList;
  late int currentReadingChapter;

  void setCurrentReadingChapter(int index) {
    currentReadingChapter = index;
  }
  bool setNextReadingChapter() {
    if (currentReadingChapter<chapUrlList.length) {
      currentReadingChapter ++;
    } else {
      return false;
    }
    return true;
  }
  bool setPreviousReadingChapter() {
    if (currentReadingChapter>0) {
      currentReadingChapter --;
    } else {
      return false;
    }
    return true;
  }
  List<String> getTags();
  Future<List<Book>> getBooks(String slug);
  Future<String> getOverview(String bookUrl);
  Future<String> getBookStatus(String bookUrl);
  Future<List<List<String>>> getTableOfContents(String bookUrl);
  Future<String> getChapterContent();
}