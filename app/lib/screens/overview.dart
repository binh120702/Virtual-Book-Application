import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/source.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  late Book book;
  String overviewData = '';
  late Source sourceInstance;
  String bookStatus = '';

  Future<void> getOverviewData() async {
    book = (ModalRoute.of(context)?.settings.arguments as Map)['book'];
    sourceInstance = (ModalRoute.of(context)?.settings.arguments as Map)['sourceInstance'];
    overviewData = await sourceInstance.getOverview(book.url);
    bookStatus = await sourceInstance.getBookStatus(book.url);
    setState(() {

    });
  }

  void onBottomBarTapped(int index) {
    switch (index) {
      case 0: {
        Navigator.pushNamed(context, '/tableofcontents', arguments: {
          'book': book,
          'sourceInstance': sourceInstance,
        });
      }
      break;
      default: print('something wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (overviewData == '') getOverviewData();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: Row(
                children: [
                  Image(image: NetworkImage(book.thumbnailURL)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.name),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: Text(
                            book.author,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          bookStatus,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: ListView(
              children: [
                Text(overviewData)
              ],
            ),
          ),
          BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_bulleted_rounded),
                  label: 'Mục lục',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Thêm vào kệ sách',
                )
              ],
            onTap: onBottomBarTapped,
          )
        ],
      )
    );
  }
}
