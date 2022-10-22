import 'package:app/models/source.dart';
import 'package:flutter/material.dart';

class TableOfContents extends StatefulWidget {
  const TableOfContents({Key? key}) : super(key: key);

  @override
  State<TableOfContents> createState() => _TableOfContentsState();
}

class _TableOfContentsState extends State<TableOfContents> {
  String bookName = '';
  String bookURL = '';
  bool came = false;
  List<Widget> widgetChapList = [];
  late Source sourceInstance;

  Future<void> getTOC() async {
    came = true;
    var args = (ModalRoute.of(context)?.settings.arguments as Map);
    sourceInstance = args['sourceInstance'];
    bookName = args['book'].name;
    bookURL = args['book'].url;
    List<List<String>> chapList = await sourceInstance.getTableOfContents(bookURL);
    setState(() {
      chapList.forEach((chap) {
        widgetChapList.add(Text(chap[0]));
      });
    });
  }

  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void goToReader(int index) {
    sourceInstance.setCurrentReadingChapter(index);
    Navigator.pushNamed(context, '/reader', arguments: {
      'sourceInstance': sourceInstance,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!came) getTOC();
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: _scrollDown,
        child: Icon(Icons.arrow_downward),
      ),
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Scrollbar(
        child: ListView.builder(
          controller: _controller,
          itemCount: widgetChapList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  goToReader(index);
                },
                title: widgetChapList[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
