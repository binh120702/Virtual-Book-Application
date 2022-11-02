import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/source.dart';

class DataHandler {
  static late List<Source> sourceInstanceList;
  static late Database db;

  static Future<void> initDatabase() async {
    sourceInstanceList = [];
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'saved_books.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE book(name TEXT, author TEXT, thumbnailURL TEXT, url TEXT PRIMARY KEY, chapNameList TEXT, chapUrlList TEXT, currentReadingChapter INTEGER, type TEXT)');
        });
    final List<Map<String, dynamic>> maps = await db.query('book');
    for (var element in maps) {sourceInstanceList.add(Source.fromJson(element));}
  }


  static Future<void> addBook(Source sourceInstance) async {
    await db.insert('book', sourceInstance.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    sourceInstanceList.add(Source.fromJson(sourceInstance.toJson()));
  }

  static Future<void> removeBook(Source sourceInstance) async {
    await db.delete('book', where: 'url = ?', whereArgs: [sourceInstance.myBook.url]);
    sourceInstanceList.remove(sourceInstance);
  }
}