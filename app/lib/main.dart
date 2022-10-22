import 'package:app/screens/bookshelf.dart';
import 'package:app/screens/overview.dart';
import 'package:app/screens/reader.dart';
import 'package:app/screens/selectSource.dart';
import 'package:app/screens/startup.dart';
import 'package:app/screens/surf.dart';
import 'package:app/screens/tableOfContents.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Startup(),
      '/bookshelf': (context) => Bookshelf(),
      '/select_source': (context) => SelectSource(),
      '/surf': (context) => Surf(),
      '/overview': (context) => Overview(),
      '/tableofcontents': (context) => TableOfContents(),
      '/reader': (context) => Reader(),
    },
  ));
}

