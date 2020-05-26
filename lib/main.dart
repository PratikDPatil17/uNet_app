import 'package:flutter/material.dart';
import 'package:uNet_app/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: '#uNet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.red[700]
      ),
      home: Home(),
      );
  }
}

