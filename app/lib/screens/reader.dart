import 'package:app/models/source.dart';
import 'package:flutter/material.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String chapterContent = '';
  late Source sourceInstance;
  bool came = false;
  final ScrollController _controller = ScrollController();
  bool showFloatButton = false;

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
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showFloatButton = true;
      });
    }
    if (_controller.offset < _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showFloatButton = false;
      });
    }
  }

  void goNextChapter() {
    if (!sourceInstance.setNextReadingChapter()) return;
    getChapterContent();
  }

  void goPreviousChapter() {
    if (!sourceInstance.setPreviousReadingChapter()) return;
    getChapterContent();
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
      floatingActionButton: Visibility(
        visible: showFloatButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.yellow.withAlpha(100),
              onPressed: goPreviousChapter,
              label: Text('Chap truoc do'),
              icon: Icon(Icons.navigate_before_rounded),
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.yellow.withAlpha(100),
              onPressed: goNextChapter,
              label: Text('Chap ke tiep'),
              icon: Icon(Icons.navigate_next_rounded),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Chapxx'),
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        backgroundColor: Color.fromRGBO(212,198,169, 1),
      ),
      backgroundColor: Color.fromRGBO(212,198,169, 1),
      body: ListView.builder(
        controller: _controller,
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                chapterContent,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(59,49,40, 1),
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: Center(child: Text('Đã hết chapter!')),
            );
          }
        },
      ),
    );
  }
}
