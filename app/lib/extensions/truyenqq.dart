import 'dart:convert';
import 'dart:math';

import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:http/http.dart';
import '../models/book.dart';
import '../models/source.dart';

class Truyenqq extends Source{
  Map<String, String> tags = {'Action': 'https://truyenqqpro.com/the-loai/action-26.html', 'Adventure': 'https://truyenqqpro.com/the-loai/adventure-27.html', 'Anime': 'https://truyenqqpro.com/the-loai/anime-62.html', 'Chuyển Sinh': 'https://truyenqqpro.com/the-loai/chuyen-sinh-91.html', 'Cổ Đại': 'https://truyenqqpro.com/the-loai/co-dai-90.html', 'Comedy': 'https://truyenqqpro.com/the-loai/comedy-28.html', 'Comic': 'https://truyenqqpro.com/the-loai/comic-60.html', 'Demons': 'https://truyenqqpro.com/the-loai/demons-99.html', 'Detective': 'https://truyenqqpro.com/the-loai/detective-100.html', 'Doujinshi': 'https://truyenqqpro.com/the-loai/doujinshi-96.html', 'Drama': 'https://truyenqqpro.com/the-loai/drama-29.html', 'Fantasy': 'https://truyenqqpro.com/the-loai/fantasy-30.html', 'Gender Bender': 'https://truyenqqpro.com/the-loai/gender-bender-45.html', 'Harem': 'https://truyenqqpro.com/the-loai/harem-47.html', 'Historical': 'https://truyenqqpro.com/the-loai/historical-51.html', 'Horror': 'https://truyenqqpro.com/the-loai/horror-44.html', 'Huyền Huyễn': 'https://truyenqqpro.com/the-loai/huyen-huyen-468.html', 'Isekai': 'https://truyenqqpro.com/the-loai/isekai-85.html', 'Josei': 'https://truyenqqpro.com/the-loai/josei-54.html', 'Mafia': 'https://truyenqqpro.com/the-loai/mafia-69.html', 'Magic': 'https://truyenqqpro.com/the-loai/magic-58.html', 'Manhua': 'https://truyenqqpro.com/the-loai/manhua-35.html', 'Manhwa': 'https://truyenqqpro.com/the-loai/manhwa-49.html', 'Martial Arts': 'https://truyenqqpro.com/the-loai/martial-arts-41.html', 'Military': 'https://truyenqqpro.com/the-loai/military-101.html', 'Mystery': 'https://truyenqqpro.com/the-loai/mystery-39.html', 'Ngôn Tình': 'https://truyenqqpro.com/the-loai/ngon-tinh-87.html', 'One shot': 'https://truyenqqpro.com/the-loai/one-shot-95.html', 'Psychological': 'https://truyenqqpro.com/the-loai/psychological-40.html', 'Romance': 'https://truyenqqpro.com/the-loai/romance-36.html', 'School Life': 'https://truyenqqpro.com/the-loai/school-life-37.html', 'Sci-fi': 'https://truyenqqpro.com/the-loai/sci-fi-43.html', 'Seinen': 'https://truyenqqpro.com/the-loai/seinen-42.html', 'Shoujo': 'https://truyenqqpro.com/the-loai/shoujo-38.html', 'Shoujo Ai': 'https://truyenqqpro.com/the-loai/shoujo-ai-98.html', 'Shounen': 'https://truyenqqpro.com/the-loai/shounen-31.html', 'Shounen Ai': 'https://truyenqqpro.com/the-loai/shounen-ai-86.html', 'Slice of life': 'https://truyenqqpro.com/the-loai/slice-of-life-46.html', 'Sports': 'https://truyenqqpro.com/the-loai/sports-57.html', 'Supernatural': 'https://truyenqqpro.com/the-loai/supernatural-32.html', 'Tragedy': 'https://truyenqqpro.com/the-loai/tragedy-52.html', 'Trọng Sinh': 'https://truyenqqpro.com/the-loai/trong-sinh-82.html', 'Truyện Màu': 'https://truyenqqpro.com/the-loai/truyen-mau-92.html', 'Webtoon': 'https://truyenqqpro.com/the-loai/webtoon-55.html', 'Xuyên Không': 'https://truyenqqpro.com/the-loai/xuyen-khong-88.html'};
  @override
  List<String> getTags() {
    return tags.keys.toList();
  }

  Future<String> bypass(String url) async {
    Response rawRes = await get(Uri.parse(url));
    var res = rawRes.body;
    final regexp = RegExp(r'document.cookie="(.*?)"');
    final x = regexp.firstMatch(res)?.group(1);
    String cookie = '';
    if (x != null) cookie = x;
    rawRes = await get(Uri.parse(url), headers: {'Cookie': cookie});
    return rawRes.body;
  }

  @override
  Future<List<Book>> getBooks(String slug, int page) async {
    String baseURL = '${tags[slug]?.substring(0, (tags[slug]?.length)!-5)}/trang-$page';
    String res = await bypass(baseURL);
    List<Book> books = [];
    final parser = HtmlParser();
    final node = parser.query(res);
    for (int i = 1; i<= min(42, HtmlParser().parseNodes(node, '//li/div/a/img').length); i++) {
      String thumbnailUrl = parser.parse(node, '//li[$i]/div/a/img@src');
      String url = parser.parse(node, '//*[@id="main_homepage"]/div[4]/ul/li[$i]/div[2]/div[1]/h3/a@href');
      String name = parser.parse(node, '//*[@id="main_homepage"]/div[4]/ul/li[$i]/div[2]/div[1]/h3/a@text');
      books.add(Book(name: name, author: '', thumbnailURL: thumbnailUrl, url: url));
    }
    if (books.isEmpty) {
      books = [Book(name: '', author: '', thumbnailURL: '', url: '')];
    }
    return books;
  }
  @override
  Future<String> getOverview(String bookUrl) async {
    String res = await bypass(bookUrl);
    return HtmlParser().parse(HtmlParser().query(res), '//body/div/div/div/div/div/p@text').trim();
  }
  @override
  Future<String> getBookStatus(String bookUrl) async {
    String tagClass = 'Đang ra';
    if (tagClass.contains('Đang ra')) {
      return 'Đang ra';
    }
    return 'Hoàn thành';
  }
  @override
  Future<bool> getTableOfContents() async {
    chapNameList = [];
    chapUrlList = [];
    String res = await bypass(myBook.url);
    for(int i = HtmlParser().parseNodes(HtmlParser().query(res), '//div[3]/div/div[3]/div/div/div/a').length; i>0; i--) {
      String name = HtmlParser().parse(HtmlParser().query(res), '//div[3]/div/div[3]/div/div[$i]/div/a@text');
      String url = HtmlParser().parse(HtmlParser().query(res), '//div[3]/div/div[3]/div/div[$i]/div/a@href');
      chapNameList.add(name);
      chapUrlList.add(url);
    }
    return true;
  }

  @override
  Future<String> getChapterContent() async {
    if (chapUrlList.isEmpty) {
      return '';
    }
    List<String> listImg = [];
    String res = await bypass(chapUrlList[currentReadingChapter]);
    final node = HtmlParser().parseNodes(HtmlParser().query(res), '//div[2]/div/img');
    for(int i = 0; i < node.length-1; i++) {
      String? url = node[i].attributes['src'];
      if (url != null) {
        if (url[0]=='/') {
          url = 'https:$url';
        }
      }
      else {
        url = '';
      }
      listImg.add(url.toString());
    }
    return '@jsonencoded${json.encode(listImg)}';
  }
}