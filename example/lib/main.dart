import 'package:example/basic_example.dart';
import 'package:example/drag_handle_example.dart';
import 'package:example/drag_into_list_example.dart';
import 'package:example/expansion_tile_example.dart';
import 'package:example/fixed_example.dart';
import 'package:example/horizontal_example.dart';
import 'package:example/list_tile_example.dart';
import 'package:example/sliver_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BasicExample(),
        '/list_tile_example': (context) => const ListTileExample(),
        '/expansion_tile_example': (context) => const ExpansionTileExample(),
        '/sliver_example': (context) => const SliverExample(),
        '/horizontal_example': (context) => const HorizontalExample(),
        '/drag_into_list_example': (context) => const DragIntoListExample(),
        '/fixed_example': (context) => const FixedExample(),
        '/drag_handle_example': (context) => const DragHandleExample(),
      },
    );
  }
}
