import 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';

class DragAndDropBuilderParameters {
  final Function(PointerMoveEvent event) onPointerMove;
  final Function(PointerUpEvent event) onPointerUp;
  final Function(PointerDownEvent event) onPointerDown;
  final Function(DragAndDropItem reorderedItem, DragAndDropItem receiverItem) onItemReordered;
  final Function(DragAndDropItem newOrReorderedItem, DragAndDropListInterface parentList, DragAndDropItemTarget receiver) onItemDropOnLastTarget;
  final Function(DragAndDropListInterface reorderedList, DragAndDropListInterface receiverList) onListReordered;
  final Axis axis;
  final CrossAxisAlignment verticalAlignment;
  final double draggingWidth;
  final bool dragOnLongPress;
  final int itemSizeAnimationDuration;
  final Widget itemGhost;
  final double itemGhostOpacity;
  final int listSizeAnimationDuration;
  final Widget listGhost;
  final double listGhostOpacity;
  final EdgeInsets listPadding;
  final Decoration listDecoration;

  DragAndDropBuilderParameters({
    @required this.onPointerMove,
    @required this.onPointerUp,
    @required this.onPointerDown,
    @required this.onItemReordered,
    @required this.onItemDropOnLastTarget,
    @required this.onListReordered,
    @required this.draggingWidth,
    this.dragOnLongPress = true,
    this.axis = Axis.vertical,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.itemSizeAnimationDuration = 150,
    this.itemGhostOpacity = 0.3,
    this.itemGhost,
    this.listSizeAnimationDuration = 150,
    this.listGhostOpacity = 0.3,
    this.listGhost,
    this.listPadding,
    this.listDecoration,
  });
}
