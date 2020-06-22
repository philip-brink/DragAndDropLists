import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_target.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item_wrapper.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropList implements DragAndDropListInterface {
  final Widget header;
  final Widget footer;
  final Widget leftSide;
  final Widget rightSide;
  final Widget contentsWhenEmpty;
  final Widget lastTarget;
  final Decoration decoration;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;
  final List<DragAndDropItem> children;

  DragAndDropList (
      {this.children,
      this.header,
      this.footer,
      this.leftSide,
      this.rightSide,
      this.contentsWhenEmpty,
      this.lastTarget,
      this.decoration,
      this.horizontalAlignment = MainAxisAlignment.start,
      this.verticalAlignment = CrossAxisAlignment.start});

  @override
  Widget generateWidget(DragAndDropBuilderParameters params) {
    var contents = List<Widget>();
    if (header != null) {
      contents.add(Flexible(child: header));
    }
    contents.add(
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: horizontalAlignment,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _generateDragAndDropListInnerContents(params),
        ),
      ),
    );
    if (footer != null) {
      contents.add(Flexible(child: footer));
    }

    return Container(
      decoration: decoration ?? params.listDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: verticalAlignment,
        children: contents,
      ),
    );
  }

  List<Widget> _generateDragAndDropListInnerContents(DragAndDropBuilderParameters params) {
    var contents = List<Widget>();
    if (leftSide != null) {
      contents.add(leftSide);
    }
    if (children != null && children.isNotEmpty) {
      List<Widget> allChildren = List<Widget>();
      children.forEach((element) => allChildren.add(DragAndDropItemWrapper(
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
        parent: this,
        parameters: params,
        onReorderOrAdd: params.onItemDropOnLastTarget,
        child: lastTarget ??
            Container(
              height: 20,
            ),
      ));
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: verticalAlignment,
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
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                contentsWhenEmpty ??
                    Text(
                      'Empty list',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                DragAndDropItemTarget(
                  parent: this,
                  parameters: params,
                  onReorderOrAdd: params.onItemDropOnLastTarget,
                  child: lastTarget ??
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
    if (rightSide != null) {
      contents.add(rightSide);
    }
    return contents;
  }
}
