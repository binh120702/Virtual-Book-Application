import 'dart:developer';

import 'package:app/extensions/extractor.dart';
import 'package:http/http.dart';
import 'package:linkify/linkify.dart';

import '../models/book.dart';
import 'package:html/parser.dart' show parse;

class Tangthuvien {
  String baseURL = 'https://truyen.tangthuvien.vn/tong-hop';
  String tocBaseURL(bookID) => 'https://truyen.tangthuvien.vn/doc-truyen/page/' + bookID + '?limit=10000';
  Map<String, String> tags = {
    'Mới cập nhật': '?ord=new',
    'Tiên hiệp': '?ord=new&ctg=1',
    'Huyền huyễn': '?ord=new&ctg=2',
    'Đô thị': '?ord=new&ctg=3',
    'Khoa huyễn': '?ord=new&ctg=4',
    'Hoàn thành': '?fns=ht',
  };
  late List<Book> bookList;
  List<String> getTags() {
    return tags.keys.toList();
  }
  Future<List<Book>> getBooks(String slug) async {
    Response rawRes = await get(Uri.parse(baseURL+tags[slug]!));
    var res = parse(rawRes.body);
    List<Book> books = [];
    print(slug);
    for(var id = 0; id < 20; id ++) {
      String name = res.getElementsByClassName('book-mid-info')[id].getElementsByTagName('a')[0].text;
      String author = res.getElementsByClassName('book-mid-info')[id].getElementsByClassName('author')[0].getElementsByTagName('a')[0].text;
      String thumbnailURL = res.getElementsByClassName('book-img-box')[id].getElementsByClassName('lazy')[0].outerHtml;
      thumbnailURL = linkify(thumbnailURL, options: const LinkifyOptions(humanize: false))[1].text;
      thumbnailURL = thumbnailURL.substring(0, thumbnailURL.length-1);
      String url= res.getElementsByClassName('book-mid-info')[id].getElementsByTagName('a')[0].outerHtml;
      url = linkify(url, options: const LinkifyOptions(humanize: false))[1].text;
      url = url.substring(0, url.length-1);
      //print('$name - $author - $thumbnailURL - $url');
      books.add(Book(name: name, author: author, thumbnailURL: thumbnailURL, url: url));
    }
    print('whut happened??');
    return books;
  }
  Future<String> getOverview(String bookUrl) async {
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String intro = res.getElementsByClassName('book-intro')[0].text;

    return intro.trim();
  }
  Future<String> getBookStatus(String bookUrl) async {
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String tagClass = res.getElementsByClassName('tag')[0].text;
    if (tagClass.contains('Đang ra')) {
      return 'Đang ra';
    }
    return 'Hoàn thành';
  }
  Future<List<List<String>>> getTableOfContents(String bookUrl) async {
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String bookID = res.getElementsByClassName('blue-btn add-book ')[0].outerHtml;
    bookID = bookID.replaceAll(RegExp(r'[^0-9]'),'');

    rawRes = await get(Uri.parse(tocBaseURL(bookID)));
    res = parse(rawRes.body);
    List temp = res.getElementsByTagName('a');
    List<List<String>> chapList = [];

    for (int i = 0; i < temp.length-1; i++){
      String url = linkify(temp[i].outerHtml.toString(), options: const LinkifyOptions(humanize: false))[1].text;
      String chapName = temp[i].text.trim();
      chapList.add([chapName, url]);
    }
    return chapList;
  }

  Future<String> getChapterContent(String chapterUrl, int index) async {
    Response rawRes = await get(Uri.parse(chapterUrl));
    var res = parse(rawRes.body);
    String bookID = res.getElementsByClassName('blue-btn add-book ')[0].outerHtml;
    bookID = bookID.replaceAll(RegExp(r'[^0-9]'),'');

    rawRes = await get(Uri.parse('https://truyen.tangthuvien.vn/story/chapters?story_id=$bookID'));
    res = parse(rawRes.body);
    List<String> chapIdList = Extractor.extract(res.outerHtml, 'ng-chap');
    String chapId = chapIdList[index];
    
    rawRes = await get(Uri.parse('https://truyen.tangthuvien.vn/get-4-chap?story_id=$bookID&sort_by_ttv=$index'));
    res = parse(rawRes.body);
    String chapContent = res.getElementsByClassName('box-chap box-chap-$chapId hidden')[0].text;
    return chapContent;
  }
}