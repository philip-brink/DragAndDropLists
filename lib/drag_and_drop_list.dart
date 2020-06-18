import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_target_internal.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropList {
  final Widget header;
  final Widget footer;
  final Widget leftSide;
  final Widget rightSide;
  final bool initiallyExpanded;
  final Widget contentsWhenEmpty;
  final Widget lastTarget;
  final Decoration decoration;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;
  final List<DragAndDropItem> children;

  DragAndDropList(
      {this.children,
      this.header,
      this.footer,
      this.leftSide,
      this.rightSide,
      this.initiallyExpanded = true,
      this.contentsWhenEmpty,
      this.lastTarget,
      this.decoration,
      this.horizontalAlignment = MainAxisAlignment.start,
      this.verticalAlignment = CrossAxisAlignment.start});

  static Widget generateDragAndDropListContents(DragAndDropList dragAndDropList, DragAndDropBuilderParameters params) {
    var contents = List<Widget>();
    if (dragAndDropList.header != null) {
      contents.add(Flexible(child: dragAndDropList.header));
    }
    contents.add(
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: dragAndDropList.horizontalAlignment,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: generateDragAndDropListInnerContents(dragAndDropList, params),
        ),
      ),
    );
    if (dragAndDropList.footer != null) {
      contents.add(Flexible(child: dragAndDropList.footer));
    }

    return Container(
      decoration: dragAndDropList.decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: dragAndDropList.verticalAlignment,
        children: contents,
      ),
    );
  }

  static List<Widget> generateDragAndDropListInnerContents(
      DragAndDropList dragAndDropList, DragAndDropBuilderParameters params) {
    var contents = List<Widget>();
    if (dragAndDropList.leftSide != null) {
      contents.add(dragAndDropList.leftSide);
    }
    if (dragAndDropList.children != null && dragAndDropList.children.isNotEmpty) {
      List<Widget> allChildren = List<Widget>();
      dragAndDropList.children.forEach((element) => allChildren.add(DragAndDropItemWrapper(
            child: element,
            onPointerDown: params.onPointerDown,
            onPointerUp: params.onPointerUp,
            onPointerMove: params.onPointerMove,
            onItemReordered: params.onItemReordered,
            sizeAnimationDuration: params.itemSizeAnimationDuration,
            ghostOpacity: params.itemGhostOpacity,
            ghost: params.itemGhost,
            dragOnLongPress: params.dragOnLongPress,
            draggingWidth: params.draggingWidth,
            axis: params.axis,
            verticalAlignment: params.verticalAlignment,
          )));
      allChildren.add(DragAndDropItemTargetInternal(
        onItemDropOnLastTarget: params.onItemDropOnLastTarget,
        ghost: params.itemGhost,
        ghostOpacity: params.itemGhostOpacity,
        sizeAnimationDuration: params.itemSizeAnimationDuration,
        parent: dragAndDropList,
        child: dragAndDropList.lastTarget ??
            Container(
              height: 20,
            ),
      ));
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: dragAndDropList.verticalAlignment,
              mainAxisSize: MainAxisSize.max,
              children: allChildren,
            ),
          ),
        ),
      );
    } else {
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: dragAndDropList.verticalAlignment,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                dragAndDropList.contentsWhenEmpty,
                dragAndDropList.lastTarget,
              ],
            ),
          ),
        ),
      );
    }
    if (dragAndDropList.rightSide != null) {
      contents.add(dragAndDropList.rightSide);
    }
    return contents;
  }
}
