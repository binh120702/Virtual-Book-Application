import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Future<void> getText() async {
    var data = {};
    data = ModalRoute.of(context)?.settings.arguments as Map;
    var chosenTag = data['chosenTag'];
    sourceInstance = data['sourceInstance'];
    books = await sourceInstance.getBooks(chosenTag);
    setState(() {
    });
  }

  void jumpToOverview(Book book) {
    print('this is overview');
    Navigator.pushNamed(context, '/overview', arguments: {
      'book': book,
      'sourceInstance': sourceInstance,
    });
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
                flex: 10,
                child: Image(image: NetworkImage(book.thumbnailURL)),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    book.name,
                    style: TextStyle(
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
                      color: Colors.grey[500],
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
    if (books.isEmpty) getText();
    return Container(
      color: Colors.white,
      child: GridView.count(
        childAspectRatio: 0.55,
        crossAxisCount: 3,
        children: getGridViewItems(),
      )
    );
  }
}
