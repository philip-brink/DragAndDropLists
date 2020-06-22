import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropListWrapper extends StatefulWidget {
  final DragAndDropListInterface dragAndDropList;
  final DragAndDropBuilderParameters parameters;

  DragAndDropListWrapper({this.dragAndDropList, this.parameters, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListWrapper();
}

class _DragAndDropListWrapper extends State<DragAndDropListWrapper> with TickerProviderStateMixin {
  DragAndDropListInterface _hoveredDraggable;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dragAndDropListContents = widget.dragAndDropList.generateWidget(widget.parameters);

    Widget draggable;
    if (widget.parameters.dragOnLongPress) {
      draggable = LongPressDraggable<DragAndDropListInterface>(
        data: widget.dragAndDropList,
        axis: widget.parameters.axis,
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
      draggable = Draggable<DragAndDropListInterface>(
        data: widget.dragAndDropList,
        axis: widget.parameters.axis,
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
                          _hoveredDraggable.generateWidget(widget.parameters),
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
          child: DragTarget<DragAndDropListInterface>(
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
              if (_hoveredDraggable != null) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
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
    if (widget.parameters.listPadding != null) {
      return Padding(
        padding: widget.parameters.listPadding,
        child: stack,
      );
    } else {
      return stack;
    }
  }
}