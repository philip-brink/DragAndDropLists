import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/widgets.dart';

class DragAndDropBuilderParameters {
  final Function(PointerMoveEvent event) onPointerMove;
  final Function(PointerUpEvent event) onPointerUp;
  final Function(PointerDownEvent event) onPointerDown;
  final Function(DragAndDropItem reorderedItem, DragAndDropItem receiverItem)
      onItemReordered;
  final Function(
      DragAndDropItem newOrReorderedItem,
      DragAndDropListInterface parentList,
      DragAndDropItemTarget receiver) onItemDropOnLastTarget;
  final Function(DragAndDropListInterface reorderedList,
      DragAndDropListInterface receiverList) onListReordered;
  final Axis axis;
  final CrossAxisAlignment verticalAlignment;
  final double listDraggingWidth;
  final bool dragOnLongPress;
  final int itemSizeAnimationDuration;
  final Widget itemGhost;
  final double itemGhostOpacity;
  final Widget itemDivider;
  final double itemDraggingWidth;
  final Decoration itemDecorationWhileDragging;
  final int listSizeAnimationDuration;
  final Widget listGhost;
  final double listGhostOpacity;
  final EdgeInsets listPadding;
  final Decoration listDecoration;
  final Decoration listDecorationWhileDragging;
  final Decoration listInnerDecoration;
  final double listWidth;
  final double lastItemTargetHeight;
  final bool addLastItemTargetHeightToTop;
  final Widget dragHandle;
  final bool dragHandleOnLeft;

  DragAndDropBuilderParameters({
    @required this.onPointerMove,
    @required this.onPointerUp,
    @required this.onPointerDown,
    @required this.onItemReordered,
    @required this.onItemDropOnLastTarget,
    @required this.onListReordered,
    @required this.listDraggingWidth,
    this.dragOnLongPress = true,
    this.axis = Axis.vertical,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.itemSizeAnimationDuration = 150,
    this.itemGhostOpacity = 0.3,
    this.itemGhost,
    this.itemDivider,
    this.itemDraggingWidth,
    this.itemDecorationWhileDragging,
    this.listSizeAnimationDuration = 150,
    this.listGhostOpacity = 0.3,
    this.listGhost,
    this.listPadding,
    this.listDecoration,
    this.listDecorationWhileDragging,
    this.listInnerDecoration,
    this.listWidth = double.infinity,
    this.lastItemTargetHeight = 20,
    this.addLastItemTargetHeightToTop = false,
    this.dragHandle,
    this.dragHandleOnLeft = false,
  });
}
