import 'package:drag_and_drop_lists/drag_and_drop_list_expansion.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ExpansionTileExample extends StatefulWidget {
  ExpansionTileExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListTileExample createState() => _ListTileExample();
}

class _ListTileExample extends State<ExpansionTileExample> {
  List<DragAndDropListExpansion> _contents;

  @override
  void initState() {
    super.initState();

    _contents = List.generate(4, (index) {
      return DragAndDropListExpansion(
        title: Text('Expansion Tile $index'),
        subtitle: Text('Subtitle $index'),
        leading: Icon(Icons.ac_unit),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.1',
              ),
              trailing: Icon(Icons.cast),
            ),
          ),
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.2',
              ),
              trailing: Icon(Icons.map),
            ),
          ),
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.3',
              ),
              trailing: Icon(Icons.adb),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expansion Tiles'),
      ),
      drawer: NavigationDrawer(),
      body: DragAndDropLists(
        children: _contents,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        // listGhost is mandatory when using expansion tiles to prevent multiple widgets using the same globalkey
        listGhost: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Icon(Icons.add_box),
            ),
          ),
        ),
      ),
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}
