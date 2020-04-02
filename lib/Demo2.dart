import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/bean/appconfig_entity.dart';
import 'package:flutterdemo/bean/handle_book_bean_entity.dart';
import 'package:flutterdemo/bean/wx_bean_entity.dart';
import 'package:flutterdemo/config/config.dart';
import 'package:flutterdemo/http/http_manager.dart';
import 'package:flutterdemo/weight/BaseAppbar.dart';

class Demo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BaseAppBar(
              title: Text(
            "23456",
            style: Theme.of(context).primaryTextTheme.headline6,
          )),
          Expanded(
              child: Center(
            child: Text("helle word"),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  child: Icon(Icons.phone_android),
                  onPressed: () => {
                        HttpManager()
                            .postAsync<List<HandleBookBeanEntity>>(
                                url: "api/v1/game/gethandbook",
                                //    params: {"cid": 294},
                                data: {
                                  "apiName": "GAME_HANDLE_BOOK",
                                  "difficulty": 1,
                                  "init": false,
                                },
                                tag: this.toStringShort())
                            .then((value) => LogUtil.v(
                                value[0].bookName + "%%%%%%%%%%%%%%%%"))
                      }),
              IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () => {
                        HttpManager()
                            .postAsync<AppconfigEntity>(
                                url:
                                    "https://zchat.zwltech.com/interface/sys.ashx ",
                                data: {
                                  "appver": "2.2.8",
                                  "sign": "a4294c6387c151f0cd1af41f51666186",
                                  "action": "appconfig",
                                  "sysver": "android,10"
                                },
                                tag: this.toStringShort())
                            .then((value) => LogUtil.e(value.apkurl))
                      })
            ],
          )
        ],
      ),
    );
  }
}
