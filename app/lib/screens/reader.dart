import 'package:flutter/material.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String chapterContent = '';
  dynamic sourceInstance;
  bool came = false;

  void getChapterContent() async {
    came = true;
    var args = (ModalRoute.of(context)?.settings.arguments as Map);
    sourceInstance = args['sourceInstance'];
    String url = args['url'];
    int index = args['chapIndex'];
    String getContent = await sourceInstance.getChapterContent(url, index);
    setState(() {
      chapterContent = getContent;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!came) getChapterContent();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapxx'),
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        backgroundColor: Color.fromRGBO(212,198,169, 1),
      ),
      backgroundColor: Color.fromRGBO(212,198,169, 1),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              chapterContent,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(59,49,40, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
