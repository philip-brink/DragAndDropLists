library drag_and_drop_lists;

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/draggable_item.dart';
import 'package:drag_and_drop_lists/draggable_list_contents.dart';
import 'package:drag_and_drop_lists/draggable_list.dart';

export 'package:drag_and_drop_lists/draggable_item.dart';
export 'package:drag_and_drop_lists/draggable_list_contents.dart';
export 'package:drag_and_drop_lists/draggable_list.dart';

class DragAndDropLists extends StatefulWidget {
  final List<DragAndDropList> dragAndDropLists;
  /// Returns -1 for [oldItemIndex] and [oldListIndex] when adding a new item.
  final Function(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) onItemReorder;
  final Function(int oldListIndex, int newListIndex) onListReorder;
  final double itemDraggingWidth;
  final Widget itemGhost;
  final double itemGhostOpacity;
  final int itemSizeAnimationDurationMilliseconds;
  final bool itemDragOnLongPress;
  final Decoration itemDecoration;
  final double listDraggingWidth;
  final Widget listGhost;
  final double listGhostOpacity;
  final int listSizeAnimationDurationMilliseconds;
  final bool listDragOnLongPress;
  final Decoration listDecoration;
  final Widget listDivider;
  final EdgeInsets listPadding;
  final Widget listItemWhenEmpty;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;

  DragAndDropLists({
    this.dragAndDropLists,
    this.onItemReorder,
    this.onListReorder,
    this.itemDraggingWidth,
    this.itemGhost,
    this.itemGhostOpacity = 0.3,
    this.itemSizeAnimationDurationMilliseconds = 150,
    this.itemDragOnLongPress = true,
    this.itemDecoration,
    this.listDraggingWidth,
    this.listGhost,
    this.listGhostOpacity = 0.3,
    this.listSizeAnimationDurationMilliseconds = 150,
    this.listDragOnLongPress = true,
    this.listDecoration,
    this.listDivider,
    this.listPadding,
    this.listItemWhenEmpty,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.horizontalAlignment = MainAxisAlignment.start,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropLists();
}

class _DragAndDropLists extends State<DragAndDropLists> {
  List<DraggableList> _draggableLists;
  ScrollController _scrollController = ScrollController();
  bool _pointerDown = false;
  double _pointerYPosition;
  double _pointerXPosition;
  bool _scrolling = false;

  @override
  Widget build(BuildContext context) {
    _draggableLists = _generateInternalList();
    var listView;

    if (widget.listDivider != null) {
      listView = ListView.separated(
        itemCount: _draggableLists.length,
        itemBuilder: (_, index) => _draggableLists[index],
        separatorBuilder: (_, index) => widget.listDivider,
        controller: _scrollController,
      );
    } else {
      listView = ListView(
        children: _draggableLists,
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 48),
      );
    }

    return listView;
  }

  List<DraggableList> _generateInternalList() {
    Widget emptyListDraggableContents;
    if (widget.listItemWhenEmpty != null) {
      emptyListDraggableContents = widget.listItemWhenEmpty;
    } else {
      emptyListDraggableContents = Text('Empty list', style: TextStyle(fontStyle: FontStyle.italic,),);
    }
    
    var draggableLists = List<DraggableList>();
    int itemId = 0;
    int emptyItemId = 0;
    int listId = 0;

    for (var list in widget.dragAndDropLists) {
      var draggableChildren = List<DraggableItem>();
      if (list.children != null) {
        for (var child in list.children) {
          draggableChildren.add(DraggableItem(
            child: child,
            draggingWidth: widget.itemDraggingWidth,
            ghost: widget.itemGhost,
            ghostOpacity: widget.itemGhostOpacity,
            sizeAnimationDuration: widget.itemSizeAnimationDurationMilliseconds,
            dragOnLongPress: widget.itemDragOnLongPress,
            onReorder: _onItemReorder,
            verticalAlignment: widget.verticalAlignment,
            id: itemId,
          ));
          itemId++;
        }
      }

      DraggableItem emptyListItem = DraggableItem.emptyItem(
        child: emptyListDraggableContents,
        draggingWidth: widget.itemDraggingWidth,
        ghostOpacity: widget.itemGhostOpacity,
        sizeAnimationDuration: widget.itemSizeAnimationDurationMilliseconds,
        onReorder: _onItemReorder,
        verticalAlignment: widget.verticalAlignment,
        id: emptyItemId,
      );
      emptyItemId++;

      var draggableListContents = DraggableListContents(
        header: list.header,
        footer: list.footer,
        leftSide: list.leftSide,
        rightSide: list.rightSide,
        decoration: widget.listDecoration,
        children: draggableChildren,
        contentsWhenEmpty: emptyListItem,
        verticalAlignment: widget.verticalAlignment,
        horizontalAlignment: widget.horizontalAlignment,
      );
      draggableLists.add(DraggableList(
        ghost: widget.listGhost,
        ghostOpacity: widget.listGhostOpacity,
        draggingWidth: widget.listDraggingWidth,
        sizeAnimationDuration: widget.listSizeAnimationDurationMilliseconds,
        dragOnLongPress: widget.listDragOnLongPress,
        padding: widget.listPadding,
        draggableListContents: draggableListContents,
        id: listId,
        onReorder: _onListReorder,
        onPointerMove: _onPointerMove,
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
      ));
      listId++;
    }

    return draggableLists;
  }

  _onItemReorder(DraggableItem reordered, DraggableItem receiver, bool placedBeforeReceiver) {
    if (widget.onItemReorder == null) return;

    int reorderedListIndex = -1;
    int reorderedItemIndex = -1;
    int receiverListIndex = -1;
    int receiverItemIndex = -1;

    if (receiver.isEmptyItem) {
      print('isEmptyItem');
      for (int i = 0; i < _draggableLists.length; i++) {
        if (reorderedItemIndex == -1) {
          reorderedItemIndex = _draggableLists[i].draggableListContents.children.indexWhere((e) => reordered.id == e.id);
          if (reorderedItemIndex != -1) reorderedListIndex = i;
        }

        if (receiverItemIndex == -1 && _draggableLists[i].draggableListContents.contentsWhenEmpty.id == receiver.id) {
          print('found');
          receiverListIndex = i;
          receiverItemIndex = 0;
        }

        if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
          break;
        }
      }
    }
    else {
      for (int i = 0; i < _draggableLists.length; i++) {
        if (reorderedItemIndex == -1) {
          reorderedItemIndex = _draggableLists[i].draggableListContents.children.indexWhere((e) => reordered.id == e.id);
          if (reorderedItemIndex != -1) reorderedListIndex = i;
        }
        if (receiverItemIndex == -1) {
          receiverItemIndex = _draggableLists[i].draggableListContents.children.indexWhere((e) => receiver.id == e.id);
          if (receiverItemIndex != -1) receiverListIndex = i;
        }
        if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
          break;
        }
      }

      if (!placedBeforeReceiver) {
        receiverItemIndex++;
      }

      if (reorderedListIndex == receiverListIndex && receiverItemIndex > reorderedItemIndex) {
        // same list, so if the new position is after the old position, the removal of the old item must be taken into account
        receiverItemIndex--;
      }
    }

    print('onItemReorder(reorderedItemIndex: $reorderedItemIndex, reorderedListIndex: $reorderedListIndex, receiverItemIndex: $receiverItemIndex, receiverListIndex: $receiverListIndex)');
    widget.onItemReorder(reorderedItemIndex, reorderedListIndex, receiverItemIndex, receiverListIndex);
  }

  _onListReorder(DraggableList reordered, DraggableList receiver, bool placedBeforeReceiver) {
    if (widget.onListReorder == null) return;

    int reorderedListIndex = _draggableLists.indexWhere((e) => reordered.id == e.id);
    int receiverListIndex = _draggableLists.indexWhere((e) => receiver.id == e.id);

    int newListIndex = receiverListIndex;

    if (!placedBeforeReceiver) {
      newListIndex++;
    }

    if (newListIndex > reorderedListIndex) {
      // same list, so if the new position is after the old position, the removal of the old item must be taken into account
      newListIndex--;
    }

    widget.onListReorder(reorderedListIndex, newListIndex);
  }

  _onPointerMove(PointerMoveEvent event) {
    if (_pointerDown) {
      _pointerYPosition = event.position.dy;
      _pointerXPosition = event.position.dx;

      _scrollList();
    }
  }

  _onPointerDown(PointerDownEvent event) {
    _pointerDown = true;
    _pointerYPosition = event.position.dy;
    _pointerXPosition = event.position.dx;
  }

  _onPointerUp(PointerUpEvent event) {
    _pointerDown = false;
  }

  _scrollList() async {
    if (!_scrolling && _pointerDown && _pointerYPosition != null && _pointerXPosition != null) {
      int duration = 30; // in ms
      int scrollAreaHeight = 60;
      double step = 1.5;
      double overDragMax = 20.0;
      double overDragCoefficient = 5.0;
      double newOffset;

      RenderBox rb = context.findRenderObject();
      var topLeftOffset = rb.localToGlobal(Offset.zero);
      var bottomRightOffset = rb.localToGlobal(rb.size.bottomRight(Offset.zero));
      double top = topLeftOffset.dy;
      double bottom = bottomRightOffset.dy;

      if (_pointerYPosition < (top + scrollAreaHeight) &&
          _scrollController.position.pixels > _scrollController.position.minScrollExtent) {
        final overDrag = max((top + scrollAreaHeight) - _pointerYPosition, overDragMax);
        newOffset = max(_scrollController.position.minScrollExtent,
            _scrollController.position.pixels - step * overDrag / overDragCoefficient);
      } else if (_pointerYPosition > (bottom - scrollAreaHeight) &&
          _scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        final overDrag = max<double>(_pointerYPosition - (bottom - scrollAreaHeight), overDragMax);
        newOffset = min(_scrollController.position.maxScrollExtent,
            _scrollController.position.pixels + step * overDrag / overDragCoefficient);
      }

      if (newOffset != null) {
        _scrolling = true;
        await _scrollController.animateTo(newOffset, duration: Duration(milliseconds: duration), curve: Curves.linear);
        _scrolling = false;
        if (_pointerDown) _scrollList();
      }
    }
  }
}

class DragAndDropList {
  Widget header;
  Widget footer;
  Widget leftSide;
  Widget rightSide;
  List<Widget> children;

  DragAndDropList({this.header, this.footer, this.leftSide, this.rightSide, this.children});
}
