import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class SliverExample extends StatefulWidget {
  const SliverExample({Key? key}) : super(key: key);

  @override
  State createState() => _SliverExample();
}

class _SliverExample extends State<SliverExample> {
  late List<DragAndDropList> _contents;
  final ScrollController _scrollController = ScrollController();

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
              child: Text('Header $index'),
            ),
            const Expanded(
              flex: 1,
              child: Divider(),
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
              child: Container(
                color: Colors.blue,
                width: 50,
                height: 30,
              ),
              feedbackWidget: Container(
                color: Colors.red,
                width: 50,
                height: 30,
              )),
          DragAndDropItem(
            child: Text('$index.2'),
          ),
          DragAndDropItem(
            child: Text('$index.3'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomNavigationDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: Container(
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Slivers',
                  style: Theme.of(context).primaryTextTheme.displayLarge,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: DragAndDropLists(
              children: _contents,
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              sliverList: true,
              scrollController: _scrollController,
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
}
