library drag_and_drop_lists;

import 'dart:math';

import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_target.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_wrapper.dart';

export 'package:drag_and_drop_lists/drag_and_drop_item.dart';
export 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
export 'package:drag_and_drop_lists/drag_and_drop_item_wrapper.dart';
export 'package:drag_and_drop_lists/drag_and_drop_list.dart';
export 'package:drag_and_drop_lists/drag_and_drop_list_target.dart';
export 'package:drag_and_drop_lists/drag_and_drop_list_wrapper.dart';
export 'package:drag_and_drop_lists/drag_and_drop_list_expansion.dart';


class DragAndDropLists extends StatefulWidget {
  final List<DragAndDropListInterface> children;

  /// Returns -1 for [oldItemIndex] and [oldListIndex] when adding a new item.
  final Function(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) onItemReorder;
  final Function(int oldListIndex, int newListIndex) onListReorder;
  final Function(DragAndDropItem newItem, int listIndex) onItemAdd;
  final Function(DragAndDropListInterface newList) onListAdd;
  final double itemDraggingWidth;
  final Widget itemTarget;
  final Widget itemGhost;
  final double itemGhostOpacity;
  final int itemSizeAnimationDurationMilliseconds;
  final bool itemDragOnLongPress;
  final Decoration itemDecoration;
  final double listDraggingWidth;
  final Widget listTarget;
  final Widget listGhost;
  final double listGhostOpacity;
  final int listSizeAnimationDurationMilliseconds;
  final bool listDragOnLongPress;
  final Decoration listDecoration;
  final Widget listDivider;
  final EdgeInsets listPadding;
  final Widget listItemWhenEmpty;
  final double listWidth;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;
  final Axis axis;
  final bool sliverList;
  final ScrollController scrollController;

  DragAndDropLists({
    this.children,
    this.onItemReorder,
    this.onListReorder,
    this.onItemAdd,
    this.onListAdd,
    this.itemDraggingWidth,
    this.itemTarget,
    this.itemGhost,
    this.itemGhostOpacity = 0.3,
    this.itemSizeAnimationDurationMilliseconds = 150,
    this.itemDragOnLongPress = true,
    this.itemDecoration,
    this.listDraggingWidth,
    this.listTarget,
    this.listGhost,
    this.listGhostOpacity = 0.3,
    this.listSizeAnimationDurationMilliseconds = 150,
    this.listDragOnLongPress = true,
    this.listDecoration,
    this.listDivider,
    this.listPadding,
    this.listItemWhenEmpty,
    this.listWidth = double.infinity,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.axis = Axis.vertical,
    this.sliverList = false,
    this.scrollController,
    Key key,
  }) : super(key: key) {
    if (listGhost == null && children.where((element) => element is DragAndDropListExpansionInterface).isNotEmpty)
      throw Exception('If using DragAndDropListExpansion, you must provide a non-null listGhost');
    if (sliverList && scrollController == null) {
      throw Exception('A scroll controller must be provided when using sliver lists');
    }
    if (axis == Axis.horizontal && listWidth == double.infinity) {
      throw Exception('A finite width must be provided when setting the axis to horizontal');
    }
    if (axis == Axis.horizontal && sliverList) {
      throw Exception('Combining a sliver list with a horizontal list is currently unsupported');
    }
  }

  @override
  State<StatefulWidget> createState() => DragAndDropListsState();
}

class DragAndDropListsState extends State<DragAndDropLists> {
  ScrollController _scrollController;
  bool _pointerDown = false;
  double _pointerYPosition;
  double _pointerXPosition;
  bool _scrolling = false;

  @override
  Widget build(BuildContext context) {
    if (_scrollController == null) {
      if (widget.scrollController != null)
        _scrollController = widget.scrollController;
      else
        _scrollController = ScrollController();
    }

    var parameters = DragAndDropBuilderParameters(
      listGhost: widget.listGhost,
      listGhostOpacity: widget.listGhostOpacity,
      draggingWidth: widget.listDraggingWidth,
      listSizeAnimationDuration: widget.listSizeAnimationDurationMilliseconds,
      dragOnLongPress: widget.listDragOnLongPress,
      listPadding: widget.listPadding,
      itemSizeAnimationDuration: widget.itemSizeAnimationDurationMilliseconds,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerMove: _onPointerMove,
      onItemReordered: _internalOnItemReorder,
      onItemDropOnLastTarget: _internalOnItemDropOnLastTarget,
      onListReordered: _internalOnListReorder,
      itemGhostOpacity: widget.itemGhostOpacity,
      verticalAlignment: widget.verticalAlignment,
      axis: widget.axis,
      itemGhost: widget.itemGhost,
      listDecoration: widget.listDecoration,
      listWidth: widget.listWidth,
    );

    DragAndDropListTarget dragAndDropListTarget = DragAndDropListTarget(
      child: widget.listTarget,
      parameters: parameters,
      onDropOnLastTarget: _internalOnListDropOnLastTarget,
    );

    Widget listView;


    if (widget.sliverList) {
      int childrenCount;
      bool includeSeparators = widget.listDivider != null;
      if (includeSeparators) childrenCount = (widget.children?.length ?? 0) * 2;
      else childrenCount = (widget.children?.length ?? 0) + 1;
      listView = SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == childrenCount - 1) {
            return dragAndDropListTarget;
          } else if (includeSeparators && index.isOdd) {
            return widget.listDivider;
          } else {
            return DragAndDropListWrapper(
              dragAndDropList: widget.children[index],
              parameters: parameters,
            );
          }
        },
        childCount: childrenCount,
        ),
      );
    } else {
      if (widget.listDivider != null) {
        listView = ListView.separated(
          scrollDirection: widget.axis,
          controller: _scrollController,
          separatorBuilder: (_, index) => widget.listDivider,
          itemCount: (widget.children?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < (widget.children?.length ?? 0)) {
              return DragAndDropListWrapper(
                dragAndDropList: widget.children[index],
                parameters: parameters,
              );
            } else {
              return dragAndDropListTarget;
            }
          },
        );
      } else {
        listView = ListView.builder(
          scrollDirection: widget.axis,
          controller: _scrollController,
          itemCount: (widget.children?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < (widget.children?.length ?? 0)) {
              return DragAndDropListWrapper(
                dragAndDropList: widget.children[index],
                parameters: parameters,
              );
            } else {
              return dragAndDropListTarget;
            }
          },
        );
      }
    }
    return listView;
  }

  _internalOnItemReorder(DragAndDropItem reordered, DragAndDropItem receiver) {
    if (widget.onItemReorder == null) return;

    int reorderedListIndex = -1;
    int reorderedItemIndex = -1;
    int receiverListIndex = -1;
    int receiverItemIndex = -1;

    for (int i = 0; i < widget.children.length; i++) {
      if (reorderedItemIndex == -1) {
        reorderedItemIndex = widget.children[i].children.indexWhere((e) => reordered == e);
        if (reorderedItemIndex != -1) reorderedListIndex = i;
      }
      if (receiverItemIndex == -1) {
        receiverItemIndex = widget.children[i].children.indexWhere((e) => receiver == e);
        if (receiverItemIndex != -1) receiverListIndex = i;
      }
      if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
        break;
      }
    }

    if (reorderedListIndex == receiverListIndex && receiverItemIndex > reorderedItemIndex) {
      // same list, so if the new position is after the old position, the removal of the old item must be taken into account
      receiverItemIndex--;
    }

    widget.onItemReorder(reorderedItemIndex, reorderedListIndex, receiverItemIndex, receiverListIndex);
  }

  _internalOnListReorder(DragAndDropListInterface reordered, DragAndDropListInterface receiver) {
    if (widget.onListReorder == null) return;

    int reorderedListIndex = widget.children.indexWhere((e) => reordered == e);
    int receiverListIndex = widget.children.indexWhere((e) => receiver == e);

    int newListIndex = receiverListIndex;

    if (newListIndex > reorderedListIndex) {
      // same list, so if the new position is after the old position, the removal of the old item must be taken into account
      newListIndex--;
    }

    widget.onListReorder(reorderedListIndex, newListIndex);
  }

  _internalOnItemDropOnLastTarget(DragAndDropItem newOrReordered, DragAndDropListInterface parentList, DragAndDropItemTarget receiver) {
    int reorderedListIndex = -1;
    int reorderedItemIndex = -1;
    int receiverListIndex = -1;
    int receiverItemIndex = -1;

    for (int i = 0; i < widget.children.length; i++) {
      if (reorderedItemIndex == -1) {
        reorderedItemIndex = widget.children[i].children.indexWhere((e) => newOrReordered == e);
        if (reorderedItemIndex != -1) reorderedListIndex = i;
      }

      if (receiverItemIndex == -1 && widget.children[i] == parentList) {
        receiverListIndex = i;
        receiverItemIndex = widget.children[i].children.length;
      }

      if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
        break;
      }
    }

    if (reorderedItemIndex == -1) {
      if (widget.onItemAdd != null) widget.onItemAdd(newOrReordered, receiverListIndex);
    } else {
      if (reorderedListIndex == receiverListIndex && receiverItemIndex > reorderedItemIndex) {
        // same list, so if the new position is after the old position, the removal of the old item must be taken into account
        receiverItemIndex--;
      }
      if (widget.onItemReorder != null)
        widget.onItemReorder(reorderedItemIndex, reorderedListIndex, receiverItemIndex, receiverListIndex);
    }
  }

  _internalOnListDropOnLastTarget(DragAndDropListInterface newOrReordered, DragAndDropListTarget receiver) {
    // determine if newOrReordered is new or existing
    int reorderedListIndex = widget.children.indexWhere((e) => newOrReordered == e);
    if (reorderedListIndex >= 0) {
      if (widget.onListReorder != null) widget.onListReorder(reorderedListIndex, widget.children.length - 1);
    } else {
      if (widget.onListAdd != null) widget.onListAdd(newOrReordered);
    }
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
      int scrollAreaHeight = 20;
      double step = 1.5;
      double overDragMax = 20.0;
      double overDragCoefficient = 5.0;
      double newOffset;

      var rb = context.findRenderObject();
      Size size;
      if (rb is RenderBox)
        size = rb.size;
      else if (rb is RenderSliver)
        size = rb.paintBounds.size;
      var topLeftOffset = localToGlobal(rb, Offset.zero);
      var bottomRightOffset = localToGlobal(rb, size.bottomRight(Offset.zero));
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

  static Offset localToGlobal(RenderObject object, Offset point, { RenderObject ancestor }) {
    return MatrixUtils.transformPoint(object.getTransformTo(ancestor), point);
  }
}
