import 'package:app/screens/bookshelf.dart';
import 'package:app/screens/startup.dart';
import 'package:app/screens/surf.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Startup(),
      '/bookshelf': (context) => Bookshelf(),
      '/surf': (context) => Surf(),
    },
  ));
}

