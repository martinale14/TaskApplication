import 'package:flutter/material.dart';
import 'package:taskapp/src/HomePage.dart';

void main() {
  //Remove this method to stop OneSignal Debugging
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  //Remove this method to stop OneSignal Debugging
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TaskApp With Js Server',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: Colors.blue,
            primaryColor: Colors.blue,
            brightness: Brightness.light),
        home: HomePage());
  }
}
