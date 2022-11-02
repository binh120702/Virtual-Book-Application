import 'dart:convert';
import 'package:app/extensions/sourceFinder.dart';

import 'book.dart';

abstract class Source {
  late Book myBook;
  late List<String> chapNameList;
  late List<String> chapUrlList;
  int currentReadingChapter = 0;

  static Source fromJson(Map<String, dynamic> jsonInstance) {
    Source instance = SourceFinder.findFromString(jsonInstance['type']);
    instance.myBook = Book(name: jsonInstance['name'], author: jsonInstance['author'], thumbnailURL: jsonInstance['thumbnailURL'], url: jsonInstance['url']);

    instance.chapNameList = [];
    for (var name in json.decode(jsonInstance['chapNameList'])) {
      instance.chapNameList.add(name.toString());
    };

    instance.chapUrlList = [];
    for (var name in json.decode(jsonInstance['chapUrlList'])) {
      instance.chapUrlList.add(name.toString());
    };

    instance.currentReadingChapter = jsonInstance['currentReadingChapter'];
    return instance;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': myBook.name,
      'author': myBook.author,
      'thumbnailURL': myBook.thumbnailURL,
      'chapNameList': json.encode(chapNameList),
      'chapUrlList': json.encode(chapUrlList),
      'url': myBook.url,
      'currentReadingChapter': currentReadingChapter,
      'type': runtimeType.toString(),
    };
  }
  String getCurrentChapterName() {
    if (chapNameList.length>0) {
      return chapNameList[currentReadingChapter];
    } else return 'Không tìm thấy chap!';
  }
  void setCurrentReadingChapter(int index) {
    currentReadingChapter = index;
  }
  bool setNextReadingChapter() {
    if (currentReadingChapter<chapUrlList.length - 1) {
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
  bool setSpecificChapter(int index) {
    if (0<=index && index<chapNameList.length) {
      currentReadingChapter = index;
      return true;
    } else {
      return false;
    }
  }
  Future<void> checkUpdate() async {
    await getTableOfContents();
  }
  List<String> getTags();
  Future<List<Book>> getBooks(String slug, int page);
  Future<String> getOverview(String bookUrl);
  Future<String> getBookStatus(String bookUrl);
  Future<bool> getTableOfContents();
  Future<String> getChapterContent();
}