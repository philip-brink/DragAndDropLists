import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropListWrapper extends StatefulWidget {
  final DragAndDropListInterface dragAndDropList;
  final DragAndDropBuilderParameters parameters;

  DragAndDropListWrapper({this.dragAndDropList, this.parameters, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListWrapper();
}

class _DragAndDropListWrapper extends State<DragAndDropListWrapper>
    with TickerProviderStateMixin {
  DragAndDropListInterface _hoveredDraggable;

  bool _draggingWithHandle = false;
  Offset _draggingWithHandleTapDownOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dragAndDropListContents =
        widget.dragAndDropList.generateWidget(widget.parameters);

    Widget draggable;
    if (widget.dragAndDropList.canDrag) {
      if (widget.parameters.dragHandle != null) {
        Widget childWithDragHandle = Stack(
          children: [
            dragAndDropListContents,
            Positioned(
              top: 0,
              right: 0,
              child: widget.parameters.dragHandle,
            ),
          ],
        );

        draggable = LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapDown: (details) {
                setState(() {
                  _draggingWithHandleTapDownOffset = details.localPosition;
                });
              },
              child: Stack(
                children: [
                  Visibility(
                    visible: !_draggingWithHandle,
                    child: dragAndDropListContents,
                  ),
                  // dragAndDropListContents,
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Draggable<DragAndDropListInterface>(
                      data: widget.dragAndDropList,
                      axis: widget.parameters.axis,
                      child: widget.parameters.dragHandle,
                      feedback: Transform.translate(
                        offset: Offset(
                            (constraints.maxWidth -
                                    _draggingWithHandleTapDownOffset.dx) -
                                constraints.maxWidth,
                            0),
                        child: Container(
                          width: widget.parameters.draggingWidth ??
                              MediaQuery.of(context).size.width,
                          child: Material(
                            color: Colors.transparent,
                            child: childWithDragHandle,
                          ),
                        ),
                      ),
                      childWhenDragging: Container(),
                      onDragStarted: () {
                        setState(() {
                          _draggingWithHandle = true;
                        });
                      },
                      onDragCompleted: () {
                        setState(() {
                          _draggingWithHandle = false;
                        });
                      },
                      onDraggableCanceled: (_, _i) {
                        setState(() {
                          _draggingWithHandle = false;
                        });
                      },
                      onDragEnd: (_) {
                        setState(() {
                          _draggingWithHandle = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else if (widget.parameters.dragOnLongPress) {
        draggable = LongPressDraggable<DragAndDropListInterface>(
          data: widget.dragAndDropList,
          axis: widget.parameters.axis,
          child: dragAndDropListContents,
          feedback: Container(
            width: widget.parameters.draggingWidth ??
                MediaQuery.of(context).size.width,
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
            width: widget.parameters.axis == Axis.vertical
                ? (widget.parameters.draggingWidth ??
                    MediaQuery.of(context).size.width)
                : (widget.parameters.draggingWidth ??
                    widget.parameters.listWidth),
            child: Material(
              child: dragAndDropListContents,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
        );
      }
    } else {
      draggable = dragAndDropListContents;
    }

    var rowOrColumnChildren = <Widget>[
      AnimatedSize(
        duration:
            Duration(milliseconds: widget.parameters.listSizeAnimationDuration),
        vsync: this,
        alignment: widget.parameters.axis == Axis.vertical
            ? Alignment.bottomCenter
            : Alignment.centerLeft,
        child: _hoveredDraggable != null
            ? Opacity(
                opacity: widget.parameters.listGhostOpacity,
                child: widget.parameters.listGhost ??
                    Container(
                      padding: widget.parameters.axis == Axis.vertical
                          ? EdgeInsets.all(0)
                          : EdgeInsets.symmetric(
                              horizontal:
                                  widget.parameters.listPadding.horizontal),
                      child:
                          _hoveredDraggable.generateWidget(widget.parameters),
                    ),
              )
            : Container(),
      ),
      Listener(
        child: draggable,
        onPointerMove: widget.parameters.onPointerMove,
        onPointerDown: widget.parameters.onPointerDown,
        onPointerUp: widget.parameters.onPointerUp,
      ),
    ];

    var stack = Stack(
      children: <Widget>[
        widget.parameters.axis == Axis.vertical
            ? Column(
                children: rowOrColumnChildren,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowOrColumnChildren,
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
                widget.parameters
                    .onListReordered(incoming, widget.dragAndDropList);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );

    Widget toReturn = stack;
    if (widget.parameters.listPadding != null) {
      toReturn = Padding(
        padding: widget.parameters.listPadding,
        child: stack,
      );
    }
    if (widget.parameters.axis == Axis.horizontal) {
      toReturn = SingleChildScrollView(
        child: Container(
          child: toReturn,
        ),
      );
    }

    return toReturn;
  }
}
