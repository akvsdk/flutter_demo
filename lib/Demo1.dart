import 'package:flutter/material.dart';

class Demo1 extends StatefulWidget {
  Demo1({Key key}) : super(key: key);

  @override
  _MyDemo1State createState() => _MyDemo1State();
}

class _MyDemo1State extends State<Demo1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lifecycle")),
      body: Container(
        height: 56.0, // 单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.pinkAccent),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
              tooltip: "哟西",
            ),
            Expanded(
              child: Container(
                child: (Text("2")),
                color: Colors.green,
              ),
              flex: 2,
            ),
            Expanded(
              child: Container(
                child: (Text("1")),
                color: Colors.black,
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                child: (Text("3")),
                color: Colors.yellow,
              ),
              flex: 3,
            ),
            IconButton(
                icon: Icon(Icons.search), tooltip: "search", onPressed: null)
          ],
        ),
      ),
    );
  }
}
