
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasicTab extends StatefulWidget {
  BasicTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BasicTabState createState() => _BasicTabState();
}

class _BasicTabState extends State<BasicTab> {
  List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();

    _contents = <DragAndDropList>[
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 1'),
            ),
            Expanded(
              flex: 1,
              child: Divider(),
            ),
          ],
        ),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 2'),
            ),
            Expanded(
              flex: 1,
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 3'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 4'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 5'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 6'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 7'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
      DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('Header 8'),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        footer: Padding(padding: EdgeInsets.symmetric(vertical: 5),),
        children: <Widget>[
          Text('Sub 1'),
          Text('Sub 2'),
          Text('Sub 3'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      dragAndDropLists: _contents,
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
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