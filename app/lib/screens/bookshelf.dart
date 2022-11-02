import 'package:app/extensions/dataHandler.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../models/source.dart';

class Bookshelf extends StatefulWidget {
  const Bookshelf({Key? key}) : super(key: key);

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {

  List<Source> books = [];

  void onBottomTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/select_source').then((value) {
        setState(() {
          books = DataHandler.sourceInstanceList;
        });
      });
    }
  }

  void goToReader(Source sourceInstance){
    Navigator.pushNamed(context, '/reader', arguments: {
      'sourceInstance': sourceInstance,
    });
  }

  Future<void> delete(Source sourceInstance) async {
    await DataHandler.removeBook(sourceInstance);
    setState(() {

    });
  }

  List<Widget> getGridViewItems() {
    return books.map<Widget> ((Source sourceInstance) {
      return FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width*0.50,
        onPressed: () {
          goToReader(sourceInstance);
        },
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        menuOffset: 10.0, // Offset value to show menuItem from the selected item
        bottomOffsetHeight: 80.0,
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(title: const Text("Open"),trailingIcon: const Icon(Icons.open_in_new) ,onPressed: (){goToReader(sourceInstance);}),
          FocusedMenuItem(title: const Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: const Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: () {delete(sourceInstance);}),
        ],
        child: Card(
            color: Colors.grey[200],
            child: Column(
              children: [
                Flexible(
                  flex: 10,
                  child: Image(image: NetworkImage(sourceInstance.myBook.thumbnailURL)),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      sourceInstance.myBook.name,
                      style: const TextStyle(
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
                    sourceInstance.myBook.author,
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            )
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    for (var element in DataHandler.sourceInstanceList) {books.add(element);}
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212,198,169, 1),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text('Kệ sách'),
      ),
      body: books.isEmpty? const Center(child: Text('Hãy thêm truyện vào kệ nhé!')) : GridView.count(
        childAspectRatio: 0.55,
        crossAxisCount: 3,
        children: getGridViewItems(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[500],
        selectedItemColor: Colors.grey[200],
        backgroundColor: Colors.brown[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Kệ sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_outlined),
            label: 'Lướt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          )
        ],
        onTap: onBottomTapped,
      ),
    );
  }
}


