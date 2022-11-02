import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notify_inapp/notify_inapp.dart';
import '../models/source.dart';
import '../extensions/dataHandler.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  String overviewData = '';
  late Source sourceInstance;
  String bookStatus = '';

  Future<void> getOverviewData() async {
    sourceInstance = (ModalRoute.of(context)?.settings.arguments as Map)['sourceInstance'];
    overviewData = await sourceInstance.getOverview(sourceInstance.myBook.url);
    bookStatus = await sourceInstance.getBookStatus(sourceInstance.myBook.url);
    setState(() {

    });
  }

  Widget message(String mes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(mes),
            )
        ),
      ],
    );
  }

  Future<void> addToDatabase() async {
    for (Source savedBook in DataHandler.sourceInstanceList) {
      if (savedBook.myBook.url == sourceInstance.myBook.url) {
        Notify notify = Notify();
        notify.show(context, message('Truyện đã có trong kệ sách rồi!'), keepDuration: 1500);
        return;
      }
    }
    await sourceInstance.checkUpdate();
    DataHandler.addBook(sourceInstance);
    Notify notify = Notify();
    notify.show(context, message('Truyện đã được thêm vào kệ sách!'), keepDuration: 1500);
  }

  void onBottomBarTapped(int index) {
    switch (index) {
      case 0: {
        Navigator.pushNamed(context, '/tableofcontents', arguments: {
          'sourceInstance': sourceInstance,
        });
      }
      break;
      case 1: {
        addToDatabase();
      }
      break;
      default: {}
    }
  }
  static List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (overviewData == '') getOverviewData();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(sourceInstance.myBook.thumbnailURL),
            fit: BoxFit.cover,
            ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Image(image: NetworkImage(sourceInstance.myBook.thumbnailURL)),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sourceInstance.myBook.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                shadows: outlinedText(strokeColor: Colors.grey.shade800)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: Text(
                                sourceInstance.myBook.author,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                  shadows: outlinedText(strokeColor: Colors.black26)
                                ),
                              ),
                            ),
                            Text(
                              bookStatus,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                shadows: outlinedText(strokeColor: Colors.black26)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    color: const Color.fromRGBO(212,198,169, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Text(overviewData)
                        ],
                      ),
                    ),
                  ),
                ),
                BottomNavigationBar(
                  elevation: 10,
                  backgroundColor: const Color.fromRGBO(212,198,169, 0.9),
                    items: const [
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
            ),
          ),
        ),
      )
    );
  }
}
