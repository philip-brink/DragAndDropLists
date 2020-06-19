import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
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
  final DragAndDropBuilderParameters parameters;

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
      this.verticalAlignment = CrossAxisAlignment.start,
      this.parameters});

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
      decoration: dragAndDropList.decoration ?? params.listDecoration,
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
      allChildren.add(DragAndDropItemTarget(
        parent: dragAndDropList,
        parameters: params,
        onReorderOrAdd: params.onItemDropOnLastTarget,
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
                dragAndDropList.contentsWhenEmpty ??
                    Text(
                      'Empty list',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                DragAndDropItemTarget(
                  parent: dragAndDropList,
                  parameters: params,
                  onReorderOrAdd: params.onItemDropOnLastTarget,
                  child: dragAndDropList.lastTarget ??
                      Container(
                        height: 20,
                      ),
                ),
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
