import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class ResultCard extends StatefulWidget {
  @override
  _ResultCardState createState() => new _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool flutterHasPassedReactNative() {
    if (fluttercount > reactNativecount) {
      return true;
    } else {
      return false;
    }
  }

  var fluttercount = 0;
  var reactNativecount = 0;
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;

  @override
  void initState() {
    super.initState();
    fetch().then((data) {
      print(data.flutterCount);
      setState(() {
        fluttercount = data.flutterCount;
        reactNativecount = data.reactNativeCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: new Transform(
        transform: new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Has Flutter passed ReactNative yet?",
                    style: TextStyle(fontSize: 15.0)),
              ),
              new Text(flutterHasPassedReactNative() == true ? "YES" : "NO",
                  style: TextStyle(fontSize: 100.0, letterSpacing: 5.0)),
                  if (( reactNativecount - fluttercount).isNegative)
                  new Text(
                  "${ fluttercount - reactNativecount } ${ reactNativecount - fluttercount == 1 ? 'star' : 'stars'} ahead!",
                  style: TextStyle(fontSize: 20.0))
                  else 
              new Text(
                  "Only ${ reactNativecount - fluttercount } ${ reactNativecount - fluttercount == 1 ? 'star' : 'stars'} away!",
                  style: TextStyle(fontSize: 20.0)),

              // this Expanded to push the row to the end of the card
              new Expanded(
                child: new Container(),
              ),
              // the row with the top center Icon
              new Stack(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 2,
                        child: new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 0.1),
                            color: Colors.white,
                          ),
                          height: 50.0,
                          child: new Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new FlutterLogo(
                                  size: 30.0,
                                ),
                                new Text("$fluttercount"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 0.1),
                            color: Colors.white,
                          ),
                          height: 50.0,
                          child: new Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  "assets/react.png",
                                  height: 30.0,
                                ),
                                new Text("$reactNativecount"),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  new FractionalTranslation(
                    translation: const Offset(0.0, -0.5),
                    child: new Center(
                      child: fluttercount == 0
                          ? RealodButton(child: CircularProgressIndicator())
                          : RealodButton(child: new Image.asset("assets/reload.png")),
                    ),
                  )
                ],
              )
            ],
          ),
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(4.0),
              border: new Border.all(width: 1.0, color: const Color.fromRGBO(221, 221, 221, 0.0)),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10.0,
                ),
              ]),
          height: 300.0,
          width: 300.0,
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    setState(() {
      fluttercount = 0;
      reactNativecount = 0;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      dragStart = null;
      dragPosition = null;
      cardOffset = const Offset(0.0, 0.0);
      fetch().then((data) {
        print(data.flutterCount);
        setState(() {
          fluttercount = data.flutterCount;
          reactNativecount = data.reactNativeCount;
        });
      });
    });
  }
}

Future<GitHubData> fetch() async {
  var URL =
      "https://wt-3680e28e08f1182ebff7681e313bb81e-0.sandbox.auth0-extend.com/fetch-github-stars";
  final response = await http.get(URL);
  final responseJson = json.decode(response.body);

  return new GitHubData.fromJson(responseJson);
}

class GitHubData {
  final int reactNativeCount;
  final int flutterCount;

  GitHubData({this.reactNativeCount, this.flutterCount});

  factory GitHubData.fromJson(Map<String, dynamic> json) {
    return new GitHubData(
      reactNativeCount: json['data']['reactNative']['stargazers']['totalCount'],
      flutterCount: json['data']['flutter']['stargazers']['totalCount'],
    );
  }
}

class RealodButton extends StatefulWidget {
  Widget child;
  RealodButton({this.child});
  @override
  _reloadbtnState createState() => new _reloadbtnState();
}

class _reloadbtnState extends State<RealodButton> {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: Colors.green,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: widget.child,
        decoration: new BoxDecoration(
            shape: BoxShape.circle, color: Colors.white, border: new Border.all(width: 0.1)),
        width: 40.0,
        height: 40.0,
      ),
    );
  }
}
