import 'package:button_navigation_bar/button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/source.dart';
import '../models/book.dart';

class Surf extends StatefulWidget {
  const Surf({Key? key}) : super(key: key);

  @override
  State<Surf> createState() => _SurfState();
}

class _SurfState extends State<Surf> {

  List<Book> books = [];
  late Source sourceInstance;
  late String sourceName;
  late String chosenTag;
  int currentPage = 1;
  final ScrollController _controller = ScrollController();
  bool reachedMax = true;

  void _scrollListener() {
    if (!_controller.position.outOfRange) {
      if (_controller.offset >= _controller.position.maxScrollExtent) {
        if (!reachedMax) {
          setState(() {
          reachedMax = true;
        });
        }
      } else {
        if (reachedMax) {
          setState(() {
            reachedMax = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void initData(){
    var data = {};
    data = ModalRoute.of(context)?.settings.arguments as Map;
    chosenTag = data['chosenTag'];
    sourceInstance = data['sourceInstance'];
    sourceName = data['source'];
  }

  Future<void> getText() async {
    books = await sourceInstance.getBooks(chosenTag, currentPage);
    setState(() {
    });
  }
  void resetController() {
    _controller.jumpTo(_controller.position.minScrollExtent);
  }

  void goNextPage() {
    currentPage++;
    getText();
    resetController();
  }

  void goPrevPage() {
    if (currentPage==1) return;
    currentPage--;
    getText();
    resetController();
  }

  void jumpToOverview(Book book) {
    if (book.url.isEmpty) {
      return;
    }
    sourceInstance.myBook = book;
    Navigator.pushNamed(context, '/overview', arguments: {
      'sourceInstance': sourceInstance,
    });
  }

  List<Widget> getGridViewItems(){
    return books.toList().map<Widget> ((Book book) {
      return Card(
        color: const Color.fromRGBO(212,198,169, 0.5),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            jumpToOverview(book);
          },
          child: Column(
            children: [
              Flexible(
                flex: 10,
                child: Image(
                  image: NetworkImage(book.thumbnailURL),
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    // Appropriate logging or analytics, e.g.
                    // myAnalytics.recordError(
                    //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                    //   exception,
                    //   stackTrace,
                    // );
                    return const Text('Không tìm thấy truyện!');
                  },
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    book.name,
                    style: const TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  book.author,
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      color: Colors.grey[300],
                      fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    if (books.isEmpty) {
      initData();
      getText();
      return Scaffold(
        backgroundColor: Colors.brown[700],
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(''),
            const SizedBox(height: 150,),
            const Image(
              image: AssetImage('assets/logo.png',),
              height: 100,
            ),
            const SizedBox(height: 150,),
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212,198,169, 1),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$sourceName - $chosenTag',
              style: const TextStyle(
                fontSize: 14
              ),
            ),
            Text(
              'Trang $currentPage',
              style: const TextStyle(
                  fontSize: 14
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        controller: _controller,
        childAspectRatio: 0.55,
        crossAxisCount: 3,
        children: getGridViewItems(),
      ),
      floatingActionButton: AnimatedContainer(
        height: reachedMax ? 50.0 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: SingleChildScrollView(
          child: ButtonNavigationBar(
            children: [
              ButtonNavigationItem(
                width: 140,
                color: const Color.fromRGBO(212,198,169, 0.5),
                onPressed: goPrevPage,
                label: 'Trước',
              ),
              ButtonNavigationItem(
                width: 140,
                color: const Color.fromRGBO(212,198,169, 0.5),
                onPressed: goNextPage,
                label: 'Tiếp',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
