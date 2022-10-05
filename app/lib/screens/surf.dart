import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';

class Surf extends StatefulWidget {
  const Surf({Key? key}) : super(key: key);

  @override
  State<Surf> createState() => _SurfState();
}

class _SurfState extends State<Surf> {

  List<Book> books = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> getText() async {
    var data = {};
    data = ModalRoute.of(context)?.settings.arguments as Map;
    var chosenTag = data['chosenTag'];
    var sourceInstance = data['sourceInstance'];
    books = await sourceInstance.getBooks(chosenTag);
    setState(() {
    });
  }

  void jumpToOverview(Book book) {
    print('this is overview');
  }

  List<Widget> getGridViewItems() {
    if (books.isEmpty) {
      return [Center(child: Text('loading'))];
    }

    return books.toList().map<Widget> ((Book book) {
      return Card(
        color: Colors.grey[200],
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            jumpToOverview(book);
          },
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Image(image: NetworkImage(book.thumbnailURL)),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(book.name,),
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
    if (books.isEmpty) getText();
    return Container(
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 2,
        children: getGridViewItems(),
      )
    );
  }
}
