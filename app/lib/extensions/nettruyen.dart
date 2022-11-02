import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:http/http.dart';
import '../models/book.dart';
import '../models/source.dart';

class Nettruyen extends Source{
  Map<String, String> tags = {'Tất cả': 'https://www.nettruyenin.com/tim-truyen', 'Action': 'https://www.nettruyenin.com/tim-truyen/action-95', 'Adult': 'https://www.nettruyenin.com/tim-truyen/truong-thanh', 'Adventure': 'https://www.nettruyenin.com/tim-truyen/adventure', 'Anime': 'https://www.nettruyenin.com/tim-truyen/anime', 'Chuyển Sinh': 'https://www.nettruyenin.com/tim-truyen/chuyen-sinh-2130', 'Comedy': 'https://www.nettruyenin.com/tim-truyen/comedy-99', 'Comic': 'https://www.nettruyenin.com/tim-truyen/comic', 'Cooking': 'https://www.nettruyenin.com/tim-truyen/cooking', 'Cổ Đại': 'https://www.nettruyenin.com/tim-truyen/co-dai-207', 'Doujinshi': 'https://www.nettruyenin.com/tim-truyen/doujinshi', 'Drama': 'https://www.nettruyenin.com/tim-truyen/drama-103', 'Đam Mỹ': 'https://www.nettruyenin.com/tim-truyen/dam-my', 'Ecchi': 'https://www.nettruyenin.com/tim-truyen/ecchi', 'Fantasy': 'https://www.nettruyenin.com/tim-truyen/fantasy-105', 'Gender Bender': 'https://www.nettruyenin.com/tim-truyen/gender-bender', 'Harem': 'https://www.nettruyenin.com/tim-truyen/harem-107', 'Historical': 'https://www.nettruyenin.com/tim-truyen/historical', 'Horror': 'https://www.nettruyenin.com/tim-truyen/horror', 'Josei': 'https://www.nettruyenin.com/tim-truyen/josei', 'Live action': 'https://www.nettruyenin.com/tim-truyen/live-action', 'Manga': 'https://www.nettruyenin.com/tim-truyen/manga-112', 'Manhua': 'https://www.nettruyenin.com/tim-truyen/manhua', 'Manhwa': 'https://www.nettruyenin.com/tim-truyen/manhwa-11400', 'Martial Arts': 'https://www.nettruyenin.com/tim-truyen/martial-arts', 'Mature': 'https://www.nettruyenin.com/tim-truyen/mature', 'Mecha': 'https://www.nettruyenin.com/tim-truyen/mecha-117', 'Mystery': 'https://www.nettruyenin.com/tim-truyen/mystery', 'Ngôn Tình': 'https://www.nettruyenin.com/tim-truyen/ngon-tinh', 'One shot': 'https://www.nettruyenin.com/tim-truyen/one-shot', 'Psychological': 'https://www.nettruyenin.com/tim-truyen/psychological', 'Romance': 'https://www.nettruyenin.com/tim-truyen/romance-121', 'School Life': 'https://www.nettruyenin.com/tim-truyen/school-life', 'Sci-fi': 'https://www.nettruyenin.com/tim-truyen/sci-fi', 'Seinen': 'https://www.nettruyenin.com/tim-truyen/seinen', 'Shoujo': 'https://www.nettruyenin.com/tim-truyen/shoujo', 'Shoujo Ai': 'https://www.nettruyenin.com/tim-truyen/shoujo-ai-126', 'Shounen': 'https://www.nettruyenin.com/tim-truyen/shounen-127', 'Shounen Ai': 'https://www.nettruyenin.com/tim-truyen/shounen-ai', 'Slice of Life': 'https://www.nettruyenin.com/tim-truyen/slice-of-life', 'Smut': 'https://www.nettruyenin.com/tim-truyen/smut', 'Soft Yaoi': 'https://www.nettruyenin.com/tim-truyen/soft-yaoi', 'Soft Yuri': 'https://www.nettruyenin.com/tim-truyen/soft-yuri', 'Sports': 'https://www.nettruyenin.com/tim-truyen/sports', 'Supernatural': 'https://www.nettruyenin.com/tim-truyen/supernatural', 'Thiếu Nhi': 'https://www.nettruyenin.com/tim-truyen/thieu-nhi', 'Tragedy': 'https://www.nettruyenin.com/tim-truyen/tragedy-136', 'Trinh Thám': 'https://www.nettruyenin.com/tim-truyen/trinh-tham', 'Truyện scan': 'https://www.nettruyenin.com/tim-truyen/truyen-scan', 'Truyện Màu': 'https://www.nettruyenin.com/tim-truyen/truyen-mau', 'Webtoon': 'https://www.nettruyenin.com/tim-truyen/webtoon', 'Xuyên Không': 'https://www.nettruyenin.com/tim-truyen/xuyen-khong-205'};
  List<String> getTags() {
    return tags.keys.toList();
  }

  Future<List<Book>> getBooks(String slug, int page) async {
    String baseURL = '${tags[slug]}?page=$page';
    String res = (await get(Uri.parse(baseURL))).body;
    List<Book> books = [];
    final node = HtmlParser().query(res);
    final imgNode = HtmlParser().parseNodes(node, '//figure/div/a/img');
    for (int i = 1; i<= 36; i++) {
      String? a = imgNode[i-1].attributes['data-original'];
      String b = HtmlParser().parse(node, '//body[1]/form[1]/main[1]/div[2]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[$i]/figure[1]/figcaption[1]/h3[1]/a@text');
      String c = HtmlParser().parse(node, '///body[1]/form[1]/main[1]/div[2]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[$i]/figure[1]/figcaption[1]/h3[1]/a@href');
      String x = 'https:${a!}';
      books.add(Book(name: b, author: '', thumbnailURL: x, url: c));
    }
    return books;
  }
  Future<String> getOverview(String bookUrl) async {
    String res = (await get(Uri.parse(bookUrl))).body;
    final node = HtmlParser().query(res);
    return HtmlParser().parse(node, '//article/div/p@text').trim();
  }
  Future<String> getBookStatus(String bookUrl) async {
    String res = (await get(Uri.parse(bookUrl))).body;
    final node = HtmlParser().query(res);
    return HtmlParser().parse(node, '//li[@class="status row"]/p[2]@text');
  }
  Future<bool> getTableOfContents() async {
    chapNameList = [];
    chapUrlList = [];
    String res = (await get(Uri.parse(myBook.url))).body;
    final node = HtmlParser().query(res);
    final pnode = HtmlParser().parseNodes(node, '//nav/ul/li');
    for (int i = pnode.length; i > 0; i--){
      chapNameList.add(HtmlParser().parse(node, '//nav/ul/li[$i]/div/a@text'));
      chapUrlList.add(HtmlParser().parse(node, '//nav/ul/li[$i]/div/a@href'));
    }
    return true;
  }

  Future<String> getChapterContent() async {
    if (chapUrlList.length==0) {
      return '';
    }
    String res = (await get(Uri.parse(chapUrlList[currentReadingChapter]))).body;
    final node = HtmlParser().query(res);
    final pnode = HtmlParser().parseNodes(node, '//nav/ul/li');
    return '';
  }
}

Future<void> tryImg() async {
  Response x = await get(Uri.parse('https://p.ntcdntempv26.com/content/image.jpg?data=QHV7EKvEkIh1x8V3VwAxQV8s4A/HItZtyn6pe+iFf/1nuyp/Rr3ZH+qh/isCQts9uoIPVJkhBmFvkJmBnwVlWvkZRWUTWnHbkLzh1CLN6eDuWG+BUOYK1y9OJOdfLM+G'), headers: {
    'data': 'QHV7EKvEkIh1x8V3VwAxQV8s4A/HItZtyn6pe iFf/1nuyp/Rr3ZH qh/isCQts9Y9GO4YdCy5D 8AqLBSqKcaU7JS4VPsjvdFwlVYI2cYDJ1Z5f8ZiR7Z5SuQ08VTMK'
  });
  print(x.body);
}

void main() {
  tryImg();
}