import 'package:flutter/material.dart';
import 'package:module_5_assignment/screens/taskListScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: MyTaskListPage()
    );
  }
}
