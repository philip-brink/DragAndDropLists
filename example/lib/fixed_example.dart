import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class FixedExample extends StatefulWidget {
  const FixedExample({Key? key}) : super(key: key);

  @override
  State createState() => _FixedExample();
}

class _FixedExample extends State<FixedExample> {
  late List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();

    _contents = List.generate(10, (index) {
      return DragAndDropList(
        header: Row(
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(index % 4 == 0
                  ? 'Header $index : Non-Draggable'
                  : 'Header $index'),
            ),
            const Expanded(
              flex: 1,
              child: Divider(),
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Text('$index.1'),
          ),
          DragAndDropItem(
            child: Text('$index.2 : Non-Draggable'),
            canDrag: false,
          ),
          DragAndDropItem(
            child: Text('$index.3'),
          ),
        ],
        canDrag: index % 4 != 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Items'),
      ),
      drawer: const CustomNavigationDrawer(),
      body: DragAndDropLists(
        children: _contents,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
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
