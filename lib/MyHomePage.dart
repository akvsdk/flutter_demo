import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Demo1.dart';
import 'package:flutterdemo/event/rxbus.dart';

import 'Demo2.dart';
import 'event/ChangeTitleEvent.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const TAG = 'haha';

  void _incrementCounter() {
    setState(() {
      _counter++;
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('提示'),
              content: Text('确认删除吗？'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    RxBus.post("sb");

                    Navigator.of(context).pop('cancel');
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确认'),
                  onPressed: () {
                    RxBus.post("666");
                    Navigator.of(context).pop('ok');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Demo2()));
                  },
                ),
              ],
            );
          });

    });
  }

  @override
  void initState() {
    super.initState();
    registerBus();
  }

  @override
  void dispose() {
    RxBus.destroy(tag: TAG);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void registerBus() {
    RxBus.register<String>(tag: TAG).listen((value) {
      setState(() {
        widget.title = value;
      });
      print(value);
    });
  }
}
