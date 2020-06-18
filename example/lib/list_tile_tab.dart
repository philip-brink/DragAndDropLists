import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

    _contents = List.generate(4, (index) {
      return DragAndDropList(
        header: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Header $index',
              ),
              subtitle: Text('Header $index subtitle'),
            ),
            Divider(),
          ],
        ),
        footer: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              title: Text(
                'Footer $index',
              ),
              subtitle: Text('Footer $index subtitle'),
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.1',
              ),
              trailing: Icon(Icons.access_alarm),
            ),
          ),
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.2',
              ),
              trailing: Icon(Icons.access_alarm),
            ),
          ),
          DragAndDropItem(
            child: ListTile(
              title: Text(
                'Sub $index.3',
              ),
              trailing: Icon(Icons.access_alarm),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      children: _contents,
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
      listGhost: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 100.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Icon(Icons.add_box),
          ),
        ),
      ),
      listPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      listItemWhenEmpty: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 40, right: 10),
              child: Divider(),
            ),
          ),
          Text('Empty List', style: TextStyle(color: Theme
              .of(context)
              .textTheme
              .caption
              .color, fontStyle: FontStyle.italic),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 40),
              child: Divider(),
            ),
          ),
        ],
      ),
      listDecoration: BoxDecoration(
        color: Theme
            .of(context)
            .canvasColor,
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
