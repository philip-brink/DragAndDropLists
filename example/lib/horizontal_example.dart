import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalExample extends StatefulWidget {
  HorizontalExample({Key? key}) : super(key: key);

  @override
  _HorizontalExample createState() => _HorizontalExample();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({required this.name, required this.children});
}

class _HorizontalExample extends State<HorizontalExample> {
  late List<InnerList> _lists;

  @override
  void initState() {
    super.initState();

    _lists = List.generate(9, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(12, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal'),
      ),
      drawer: NavigationDrawer(),
      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: 150,
        listDraggingWidth: 150,
        listDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        listPadding: EdgeInsets.all(8.0),
      ),
    );
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    return DragAndDropList(
      header: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
                color: Colors.pink,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                'Header ${innerList.name}',
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
            ),
          ),
        ],
      ),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(7.0)),
                color: Colors.pink,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                'Footer ${innerList.name}',
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
            ),
          ),
        ],
      ),
      leftSide: VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      children: List.generate(innerList.children.length,
          (index) => _buildItem(innerList.children[index])),
    );
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child: ListTile(
        title: Text(item),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
