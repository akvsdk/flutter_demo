import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/config/config.dart';
import 'package:flutterdemo/http/head_interceptor.dart';
import 'Constant.dart';
import 'Demo1.dart';
import 'Demo2.dart';
import 'MyHomePage.dart';
import 'http/http_manager.dart';
import 'http/log_interceptor.dart';

void main() {
//  await SpUtil.getInstance();
  LogUtil.init(isDebug: true, tag: "J1ang");
  HttpManager().init(
    baseUrl: Config.BASE_URL,
    interceptors: [
      HeadInterceptor(),
      LogsInterceptors(),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        demo1: (context) => Demo1(),
        demo2: (context) => Demo2(),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
