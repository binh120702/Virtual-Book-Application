import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  late Book book;
  String overviewData = '';
  dynamic sourceInstance;

  Future<void> getOverviewData() async {
    book = (ModalRoute.of(context)?.settings.arguments as Map)['book'];
    sourceInstance = (ModalRoute.of(context)?.settings.arguments as Map)['sourceInstance'];
    overviewData = await sourceInstance.getOverview(book.url);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (overviewData == '') getOverviewData();
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: ListView(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Image(image: NetworkImage(book.thumbnailURL))
                ),
                Flexible(
                    flex: 1,
                    child: Text(book.name),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(overviewData)
          )
        ],
      )
    );
  }
}
