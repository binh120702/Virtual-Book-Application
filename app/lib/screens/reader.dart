import 'package:app/models/source.dart';
import 'package:button_navigation_bar/button_navigation_bar.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String chapterContent = '';
  String readingPercent = '0.0';
  late Source sourceInstance;
  bool came = false;
  final ScrollController _controller = ScrollController();
  bool selected = false;
  void getChapterContent() async {
    setState(() {
      chapterContent = '';
    });
    String getContent = await sourceInstance.getChapterContent();
    setState(() {
      chapterContent = getContent;
    });
  }

  void _scrollListener() {
    if (!_controller.position.outOfRange) {
      readingPercent = (_controller.offset*100 / _controller.position.maxScrollExtent).toStringAsFixed(1);
      setState(() {

      });
    }
  }

  void goNextChapter() {
    if (!sourceInstance.setNextReadingChapter()) return;
    readingPercent = '0.0';
    getChapterContent();
  }

  void goPreviousChapter() {
    if (!sourceInstance.setPreviousReadingChapter()) return;
    readingPercent = '0.0';
    getChapterContent();
  }

  void changeBottomButtonState() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!came) {
      came = true;
      var args = (ModalRoute.of(context)?.settings.arguments as Map);
      sourceInstance = args['sourceInstance'];
      getChapterContent();
    }
    return Scaffold(
      drawer: SidebarX(
        controller: SidebarXController(selectedIndex: 0, extended: true),
        items: const [
          SidebarXItem(icon: Icons.home, label: 'Homee'),
          SidebarXItem(icon: Icons.search, label: 'Search'),
        ],
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Text(
                sourceInstance.getCurrentChapterName(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(59,49,40, 1),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                '$readingPercent%',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(59,49,40, 1),
                ),
              )
            )
          ],
        ),
        toolbarHeight: 30,
        backgroundColor: Color.fromRGBO(212,198,169, 1),
      ),
      backgroundColor: Color.fromRGBO(212,198,169, 1),
      body: ListView.builder(
        controller: _controller,
        itemCount: 2,
        itemBuilder: (context, index) {
            return GestureDetector(
              onTap: changeBottomButtonState,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  chapterContent,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Color.fromRGBO(59, 49, 40, 1),
                  ),
                ),
              ),
            );
          }
      ),
      floatingActionButton: AnimatedContainer(
        height: selected ? 50.0 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: SingleChildScrollView(
          child: ButtonNavigationBar(
            children: [
              ButtonNavigationItem(
                color: Color.fromRGBO(212,198,169, 0.5),
                onPressed: goPreviousChapter,
                label: 'Trước',
              ),
              ButtonNavigationItem(
                color: Color.fromRGBO(212,198,169, 0.5),
                width: 140,
                onPressed: () {},
                label: 'category',
              ),
              ButtonNavigationItem(
                color: Color.fromRGBO(212,198,169, 0.5),
                onPressed: goNextChapter,
                label: 'Tiếp',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
