import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  @override
  PlaygroundState createState() => new PlaygroundState();
}

class PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("操场"),
          backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: new Center(
          child: new Text('操场'),
        ),
      ),
    );
  }
}