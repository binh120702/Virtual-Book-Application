import 'package:app/models/source.dart';
import 'package:flutter/material.dart';

class TableOfContents extends StatefulWidget {
  const TableOfContents({Key? key}) : super(key: key);

  @override
  State<TableOfContents> createState() => _TableOfContentsState();
}

class _TableOfContentsState extends State<TableOfContents> {
  bool came = false;
  List<Widget> widgetChapList = [];
  late Source sourceInstance;

  Future<void> getTOC() async {
    came = true;
    var args = (ModalRoute.of(context)?.settings.arguments as Map);
    sourceInstance = args['sourceInstance'];
    if (await sourceInstance.getTableOfContents()) {
      setState(() {
        for (var chap in sourceInstance.chapNameList) {
          widgetChapList.add(Text(chap));
        }
      });
    }
  }

  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
  void _scrollUp() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 1),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!came) getTOC();
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            backgroundColor: const Color.fromRGBO(212,198,169, 0.5),
            heroTag: 'btn1',
            onPressed: _scrollUp,
            child: const Icon(Icons.arrow_upward),
          ),
          FloatingActionButton.small(
            backgroundColor: const Color.fromRGBO(212,198,169, 0.5),
            heroTag: 'btn2',
            onPressed: _scrollDown,
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(sourceInstance.myBook.name),
        backgroundColor: const Color.fromRGBO(212,198,169, 1),
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
