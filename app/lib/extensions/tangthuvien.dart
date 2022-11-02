import 'package:app/extensions/extractor.dart';
import 'package:app/models/source.dart';
import 'package:http/http.dart';
import 'package:linkify/linkify.dart';

import '../models/book.dart';
import 'package:html/parser.dart' show parse;

class Tangthuvien extends Source{
  Map<String, String> tags = {
    'Mới cập nhật': '?ord=new',
    'Tiên hiệp': '?ord=new&ctg=1',
    'Huyền huyễn': '?ord=new&ctg=2',
    'Đô thị': '?ord=new&ctg=3',
    'Khoa huyễn': '?ord=new&ctg=4',
    'Hoàn thành': '?fns=ht',
  };
  @override
  List<String> getTags() {
    return tags.keys.toList();
  }
  @override
  Future<List<Book>> getBooks(String slug, int page) async {
    String baseURL = 'https://truyen.tangthuvien.vn/tong-hop';

    Response rawRes = await get(Uri.parse('$baseURL${tags[slug]!}&page=$page'));
    var res = parse(rawRes.body);
    List<Book> books = [];
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
    return books;
  }
  @override
  Future<String> getOverview(String bookUrl) async {
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String intro = res.getElementsByClassName('book-intro')[0].text;

    return intro.trim();
  }
  @override
  Future<String> getBookStatus(String bookUrl) async {
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String tagClass = res.getElementsByClassName('tag')[0].text;
    if (tagClass.contains('Đang ra')) {
      return 'Đang ra';
    }
    return 'Hoàn thành';
  }
  @override
  Future<bool> getTableOfContents() async {
    chapNameList = [];
    chapUrlList = [];
    String bookUrl = myBook.url;
    String tocBaseURL(bookID) => 'https://truyen.tangthuvien.vn/doc-truyen/page/$bookID?limit=10000';
    Response rawRes = await get(Uri.parse(bookUrl));
    var res = parse(rawRes.body);
    String bookID = res.getElementsByClassName('blue-btn add-book ')[0].outerHtml;
    bookID = bookID.replaceAll(RegExp(r'[^0-9]'),'');

    rawRes = await get(Uri.parse(tocBaseURL(bookID)));
    res = parse(rawRes.body);
    List temp = res.getElementsByTagName('a');

    for (int i = 0; i < temp.length-1; i++){
      String url = linkify(temp[i].outerHtml.toString(), options: const LinkifyOptions(humanize: false))[1].text;
      String chapName = temp[i].text.trim();
      String realUrl = url.substring(0, url.length-1);
      chapNameList.add(chapName);
      chapUrlList.add(realUrl);
    }
    return true;
  }

  @override
  Future<String> getChapterContent() async {
    if (chapUrlList.isEmpty) {
      return '';
    }
    Response rawRes = await get(Uri.parse(chapUrlList[currentReadingChapter]));
    var res = parse(rawRes.body);
    String chapID  = Extractor.extract(res.outerHtml, 'openWarningBox', '\'')[0];

    // rawRes = await get(Uri.parse('https://truyen.tangthuvien.vn/get-4-chap?story_id=$bookID&sort_by_ttv=$index'));
    // res = parse(rawRes.body);
    String chapContent = res.getElementsByClassName('box-chap box-chap-$chapID')[0].text;
    return chapContent;
  }
}