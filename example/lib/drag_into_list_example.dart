import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragIntoListExample extends StatefulWidget {
  DragIntoListExample({Key? key}) : super(key: key);

  @override
  _DragIntoListExample createState() => _DragIntoListExample();
}

class _DragIntoListExample extends State<DragIntoListExample> {
  List<DragAndDropList> _contents = <DragAndDropList>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag Into List'),
      ),
      drawer: NavigationDrawer(),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 10,
            child: DragAndDropLists(
              children: _contents,
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              onItemAdd: _onItemAdd,
              onListAdd: _onListAdd,
              listGhost: Container(
                height: 50,
                width: 100,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.pink,
                    child: Center(
                      child: Draggable<DragAndDropListInterface>(
                        feedback: Icon(Icons.assignment),
                        child: Icon(Icons.assignment),
                        data: DragAndDropList(
                          header: Text(
                            'New default list',
                          ),
                          children: <DragAndDropItem>[],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.orange,
                    child: Center(
                      child: Draggable<DragAndDropItem>(
                        feedback: Icon(Icons.photo),
                        child: Icon(Icons.photo),
                        data: DragAndDropItem(child: Text('New default item')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  _onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    print('adding new item');
    setState(() {
      if (itemIndex == -1)
        _contents[listIndex].children.add(newItem);
      else
        _contents[listIndex].children.insert(itemIndex, newItem);
    });
  }

  _onListAdd(DragAndDropListInterface newList, int listIndex) {
    print('adding new list');
    setState(() {
      if (listIndex == -1)
        _contents.add(newList as DragAndDropList);
      else
        _contents.insert(listIndex, newList as DragAndDropList);
    });
  }
}
