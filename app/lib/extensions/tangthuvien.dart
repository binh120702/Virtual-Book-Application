import 'dart:developer';

import 'package:http/http.dart';
import 'package:linkify/linkify.dart';

import '../models/book.dart';
import 'package:html/parser.dart' show parse;

class Tangthuvien {
  String baseURL = 'https://truyen.tangthuvien.vn/tong-hop?ord=new';
  Map<String, String> tags = {
    'Moi cap nhat': '',
    'Tien Hiep': '&ctg=1',
    'Huyen Huyen': '&ctg=2',
    'Do thi': '&ctg=3',
    'Khoa huyen': '&ctg=4',
    'Moi cap nhat1': '',
    'Tien Hiep1': '&ctg=1',
    'Huyen Huyen1': '&ctg=2',
    'Do thi1': '&ctg=3',
    'Khoa huyen1': '&ctg=4',
    'Moi cap nhat2': '',
    'Tien Hiep2': '&ctg=1',
    'Huyen Huyen2': '&ctg=2',
    'Do thi2': '&ctg=3',
    'Khoa huyen2': '&ctg=4',
  };
  late List<Book> bookList;
  List<String> getTags() {
    return tags.keys.toList();
  }
  Future<List<Book>> getBooks(String slug) async {
    Response rawRes = await get(Uri.parse(baseURL+slug));
    var res = parse(rawRes.body);
    List<Book> books = [];
    for(var id = 0; id < 20; id ++) {
      String name = res.getElementsByClassName('book-mid-info')[id].getElementsByTagName('a')[0].text;
      String author = res.getElementsByClassName('book-mid-info')[id].getElementsByClassName('author')[0].getElementsByTagName('a')[0].text;
      String thumbnailURL = res.getElementsByClassName('book-img-box')[id].getElementsByClassName('lazy')[0].outerHtml;
      thumbnailURL = linkify(thumbnailURL, options: const LinkifyOptions(humanize: false))[1].text;
      thumbnailURL = thumbnailURL.substring(0, thumbnailURL.length-1);
      //print('$name - $author - $thumbnailURL');
      books.add(Book(name: name, author: author, thumbnailURL: thumbnailURL, url: ''));
    }
    print('whut happened??');
    return books;
  }
}