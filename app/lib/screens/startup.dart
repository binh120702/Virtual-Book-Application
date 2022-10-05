import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Startup extends StatefulWidget {
  const Startup({Key? key}) : super(key: key);

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {

  void move() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushReplacementNamed(context, '/bookshelf');
    print('whut??');
  }

  @override
  void initState() {
    super.initState();
    move();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[700],
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(''),
          SizedBox(height: 150,),
          Image(
            image: AssetImage('assets/logo.png',),
            height: 100,
          ),
          SizedBox(height: 150,),
          SpinKitThreeBounce(
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}

