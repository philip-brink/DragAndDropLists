import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/widgets.dart';

typedef OnPointerMove = void Function(PointerMoveEvent event);
typedef OnPointerUp = void Function(PointerUpEvent event);
typedef OnPointerDown = void Function(PointerDownEvent event);
typedef OnItemReordered = void Function(
  DragAndDropItem reorderedItem,
  DragAndDropItem receiverItem,
);
typedef OnItemDropOnLastTarget = void Function(
  DragAndDropItem newOrReorderedItem,
  DragAndDropListInterface parentList,
  DragAndDropItemTarget receiver,
);
typedef OnListReordered = void Function(
  DragAndDropListInterface reorderedList,
  DragAndDropListInterface receiverList,
);

class DragAndDropBuilderParameters {
  final OnPointerMove? onPointerMove;
  final OnPointerUp? onPointerUp;
  final OnPointerDown? onPointerDown;
  final OnItemReordered? onItemReordered;
  final OnItemDropOnLastTarget? onItemDropOnLastTarget;
  final OnListReordered? onListReordered;
  final ListOnWillAccept? listOnWillAccept;
  final ListTargetOnWillAccept? listTargetOnWillAccept;
  final OnListDraggingChanged? onListDraggingChanged;
  final ItemOnWillAccept? itemOnWillAccept;
  final ItemTargetOnWillAccept? itemTargetOnWillAccept;
  final OnItemDraggingChanged? onItemDraggingChanged;
  final Axis axis;
  final CrossAxisAlignment verticalAlignment;
  final double? listDraggingWidth;
  final bool dragOnLongPress;
  final int itemSizeAnimationDuration;
  final Widget? itemGhost;
  final double itemGhostOpacity;
  final Widget? itemDivider;
  final double? itemDraggingWidth;
  final Decoration? itemDecorationWhileDragging;
  final int listSizeAnimationDuration;
  final Widget? listGhost;
  final double listGhostOpacity;
  final EdgeInsets? listPadding;
  final Decoration? listDecoration;
  final Decoration? listDecorationWhileDragging;
  final Decoration? listInnerDecoration;
  final double listWidth;
  final double lastItemTargetHeight;
  final bool addLastItemTargetHeightToTop;
  final DragHandle? listDragHandle;
  final DragHandle? itemDragHandle;
  final bool constrainDraggingAxis;
  final bool disableScrolling;

  DragAndDropBuilderParameters({
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerDown,
    this.onItemReordered,
    this.onItemDropOnLastTarget,
    this.onListReordered,
    this.listDraggingWidth,
    this.listOnWillAccept,
    this.listTargetOnWillAccept,
    this.onListDraggingChanged,
    this.itemOnWillAccept,
    this.itemTargetOnWillAccept,
    this.onItemDraggingChanged,
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
    this.listDragHandle,
    this.itemDragHandle,
    this.constrainDraggingAxis = true,
    this.disableScrolling = false,
  });
}
