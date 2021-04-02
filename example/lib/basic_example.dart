import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasicExample extends StatefulWidget {
  BasicExample({Key? key}) : super(key: key);

  @override
  _BasicExample createState() => _BasicExample();
}

class _BasicExample extends State<BasicExample> {
  late List<DragAndDropList> _contents;
  late List<DnDList> _contentsReworked;

  @override
  void initState() {
    super.initState();

    // _contents = List.generate(10, (index) {
    //   return DragAndDropList(
    //     header: Row(
    //       children: <Widget>[
    //         Expanded(
    //           flex: 1,
    //           child: Divider(),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //           child: Text('Header $index'),
    //         ),
    //         Expanded(
    //           flex: 1,
    //           child: Divider(),
    //         ),
    //       ],
    //     ),
    //     children: <DragAndDropItem>[
    //       DragAndDropItem(
    //         child: Text('$index.1'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.2'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.3'),
    //       ),
    //     ],
    //   );
    // });

    _contentsReworked = List.generate(
      50,
      (listIndex) => DnDList(
        header: 'List $listIndex',
        children: List.generate(
          5,
          (itemIndex) => DnDItem(
            child: Text('$listIndex.$itemIndex'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic'),
      ),
      drawer: NavigationDrawer(),
      // body: DragAndDropLists(
      //   children: _contents,
      //   onItemReorder: _onItemReorder,
      //   onListReorder: _onListReorder,
      // ),
      // body: ReworkedDragAndDropListsView(
      //   buildDefaultDragHandles: false,
      //   onReorder: _reworkedListReorder,
      //   children: List.generate(
      //     _contentsReworked.length,
      //     (listIndex) => ListTile(
      //       key: Key('$listIndex'),
      //       tileColor: listIndex.isOdd ? Colors.pink : Colors.greenAccent,
      //       title: Text(_contentsReworked[listIndex].header),
      //     ),
      //   ),
      // ),
      body: ReworkedDragAndDropListsView.builder(
        onReorder: _reworkedListReorder,
        listCount: _contentsReworked.length,
        listBuilder: (context, listIndex) => ListTile(
          key: ValueKey(listIndex),
          title: Text(_contentsReworked[listIndex].header),
        ),
      ),
    );
  }

  _reworkedListReorder(int from, int to) {
    print('from $from to $to');
    var element = _contentsReworked.removeAt(from);
    setState(() {
      _contentsReworked.insert(from > to ? to : to - 1, element);
    });
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

class DnDList {
  final String header;
  final List<DnDItem> children;

  DnDList({required this.header, required this.children});
}

class DnDItem {
  final Widget child;

  DnDItem({required this.child});
}
