

import 'package:flutter/material.dart';
import 'package:so/ResultCard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new page(),
    );
  }
}

class page extends StatefulWidget {
  @override
  _pageState createState() => new _pageState();
}

class _pageState extends State<page> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Has Flutter passed ReactNative yet?",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: new Center(
        child: new ResultCard(),
      ),
    );
  }
}


