import 'package:example/basic_tab.dart';
import 'package:example/list_tile_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Drag and Drop Lists'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.list), text: 'Basic',),
                Tab(icon: Icon(Icons.view_list), text: 'List Tile',),
                Tab(icon: Icon(Icons.add), text: 'Drag In',),
                Tab(icon: Icon(Icons.drag_handle), text: 'Handle',),
                Tab(icon: Icon(Icons.swap_horiz), text: 'Horizontal',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              BasicTab(),
              ListTileTab(),
              BasicTab(),
              BasicTab(),
              BasicTab(),
            ],
          ),
        ),
      ),
    );
  }
}



















