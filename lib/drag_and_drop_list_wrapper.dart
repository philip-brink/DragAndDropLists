import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropListWrapper extends StatefulWidget {
  final DragAndDropList dragAndDropList;
  final DragAndDropBuilderParameters parameters;

  DragAndDropListWrapper({this.dragAndDropList, this.parameters, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListWrapper();
}

class _DragAndDropListWrapper extends State<DragAndDropListWrapper> with TickerProviderStateMixin {
  DragAndDropList _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    Widget dragAndDropListContents = DragAndDropList.generateDragAndDropListContents(widget.dragAndDropList, widget.parameters);

    Widget draggable;
    if (widget.parameters.dragOnLongPress) {
      draggable = LongPressDraggable<DragAndDropList>(
        data: widget.dragAndDropList,
        axis: Axis.vertical,
        child: dragAndDropListContents,
        feedback: Container(
          width: widget.parameters.draggingWidth ?? MediaQuery.of(context).size.width,
          child: Material(
            child: dragAndDropListContents,
            color: Colors.transparent,
          ),
        ),
        childWhenDragging: Container(),
      );
    } else {
      draggable = Draggable<DragAndDropList>(
        data: widget.dragAndDropList,
        axis: Axis.vertical,
        child: dragAndDropListContents,
        feedback: Container(
          width: widget.parameters.draggingWidth ?? MediaQuery.of(context).size.width,
          child: Material(
            child: dragAndDropListContents,
            color: Colors.transparent,
          ),
        ),
        childWhenDragging: Container(),
      );
    }

    var stack = Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: widget.parameters.listSizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters.listGhostOpacity,
                      child: widget.parameters.listGhost ??
                          DragAndDropList.generateDragAndDropListContents(_hoveredDraggable, widget.parameters),
                    )
                  : Container(),
            ),
            Listener(
              child: draggable,
              onPointerMove: widget.parameters.onPointerMove,
              onPointerDown: widget.parameters.onPointerDown,
              onPointerUp: widget.parameters.onPointerUp,
            ),
          ],
        ),
        Positioned.fill(
          child: DragTarget<DragAndDropList>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData != null && candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              setState(() {
                _hoveredDraggable = incoming;
              });
              return true;
            },
            onLeave: (incoming) {
              setState(() {
                _hoveredDraggable = null;
              });
            },
            onAccept: (incoming) {
              setState(() {
                widget.parameters.onListReordered(incoming, widget.dragAndDropList);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );
    if (widget.parameters.padding != null) {
      return Padding(
        padding: widget.parameters.padding,
        child: stack,
      );
    } else {
      return stack;
    }
  }
}