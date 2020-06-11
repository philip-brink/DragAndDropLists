import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListTileTab extends StatefulWidget {
  ListTileTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListTileTabState createState() => _ListTileTabState();
}

class _ListTileTabState extends State<ListTileTab> {
  List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();

    _contents = <DragAndDropList>[
      DragAndDropList(
        header: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Header 1',
              ),
              subtitle: Text('Header 1 subtitle'),
            ),
            Divider(),
          ],
        ),
        footer: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              title: Text(
                'Footer 1',
              ),
              subtitle: Text('Footer 1 subtitle'),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              'Sub 1.1',
            ),
            trailing: Icon(Icons.access_alarm),
          ),
          ListTile(
            title: Text('Sub 1.2'),
            trailing: Icon(Icons.alarm_add),
          ),
          ListTile(
            title: Text('Sub 1.3'),
            trailing: Icon(Icons.alarm_off),
          ),
        ],
      ),
      DragAndDropList(
        header: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Header 2',
              ),
              subtitle: Text('Header 2 subtitle'),
            ),
            Divider(),
          ],
        ),
        footer: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              title: Text(
                'Footer 2',
              ),
              subtitle: Text('Footer 2 subtitle'),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              'Sub 2.1',
            ),
            trailing: Icon(Icons.access_alarm),
          ),
          ListTile(
            title: Text('Sub 2.2'),
            trailing: Icon(Icons.alarm_add),
          ),
          ListTile(
            title: Text('Sub 2.3'),
            trailing: Icon(Icons.alarm_off),
          ),
        ],
      ),
      DragAndDropList(
        header: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Header 3',
              ),
              subtitle: Text('Header 3 subtitle'),
            ),
            Divider(),
          ],
        ),
        footer: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              title: Text(
                'Footer 3',
              ),
              subtitle: Text('Footer 3 subtitle'),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              'Sub 3.1',
            ),
            trailing: Icon(Icons.access_alarm),
          ),
          ListTile(
            title: Text('Sub 3.2'),
            trailing: Icon(Icons.alarm_add),
          ),
          ListTile(
            title: Text('Sub 3.3'),
            trailing: Icon(Icons.alarm_off),
          ),
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
      listPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      listDecoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
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
