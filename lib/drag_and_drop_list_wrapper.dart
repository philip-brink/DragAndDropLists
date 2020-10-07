import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/measure_size.dart';
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

  bool _dragging = false;
  Size _draggingWithHandleContainerSize = Size.zero;
  double _draggingWithHandleContainerLeftPosition = 0;
  Size _draggingWithHandleDragHandleSize = Size.zero;
  double _draggingWithHandleDragHandleLeftPosition = 0;

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
        double dragHandleCenter = _draggingWithHandleDragHandleLeftPosition +
            (_draggingWithHandleDragHandleSize.width / 2.0);
        double containerLeftToDragHandleCenter =
            dragHandleCenter - _draggingWithHandleContainerLeftPosition;

        Widget feedback = Container(
          width: widget.parameters.listDraggingWidth ??
              _draggingWithHandleContainerSize.width,
          child: Stack(
            children: [
              dragAndDropListContents,
              Positioned(
                right: widget.parameters.dragHandleOnLeft ? null : 0,
                left: widget.parameters.dragHandleOnLeft ? 0 : null,
                top: 0,
                child: widget.parameters.dragHandle,
              ),
            ],
          ),
        );

        draggable = MeasureSize(
          onSizeChange: (size) {
            setState(() {
              _draggingWithHandleContainerSize = size;
            });
          },
          onLeftPositionChange: (leftPosition) {
            setState(() {
              _draggingWithHandleContainerLeftPosition = leftPosition;
            });
          },
          child: Stack(
            children: [
              Visibility(
                visible: !_dragging,
                child: dragAndDropListContents,
              ),
              // dragAndDropListContents,
              Positioned(
                right: widget.parameters.dragHandleOnLeft ? null : 0,
                left: widget.parameters.dragHandleOnLeft ? 0 : null,
                top: 0,
                child: Draggable<DragAndDropListInterface>(
                  data: widget.dragAndDropList,
                  axis: widget.parameters.axis == Axis.vertical
                      ? Axis.vertical
                      : null,
                  child: MeasureSize(
                    onSizeChange: (size) {
                      setState(() {
                        _draggingWithHandleDragHandleSize = size;
                      });
                    },
                    onLeftPositionChange: (leftPosition) {
                      setState(() {
                        _draggingWithHandleDragHandleLeftPosition =
                            leftPosition;
                      });
                    },
                    child: widget.parameters.dragHandle,
                  ),
                  feedback: Transform.translate(
                    offset: Offset(
                        -containerLeftToDragHandleCenter +
                            _draggingWithHandleContainerLeftPosition,
                        0),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration:
                            widget.parameters.listDecorationWhileDragging,
                        child: feedback,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(),
                  onDragStarted: () => _setDragging(true),
                  onDragCompleted: () => _setDragging(false),
                  onDraggableCanceled: (_, __) => _setDragging(false),
                  onDragEnd: (_) => _setDragging(false),
                ),
              ),
            ],
          ),
        );
      } else if (widget.parameters.dragOnLongPress) {
        draggable = LongPressDraggable<DragAndDropListInterface>(
          data: widget.dragAndDropList,
          axis: widget.parameters.axis,
          child: dragAndDropListContents,
          feedback: Container(
            width: widget.parameters.listDraggingWidth ??
                MediaQuery.of(context).size.width,
            child: Material(
              child: dragAndDropListContents,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
          onDragStarted: () => _setDragging(true),
          onDragCompleted: () => _setDragging(false),
          onDraggableCanceled: (_, __) => _setDragging(false),
          onDragEnd: (_) => _setDragging(false),
        );
      } else {
        draggable = Draggable<DragAndDropListInterface>(
          data: widget.dragAndDropList,
          axis: widget.parameters.axis,
          child: dragAndDropListContents,
          feedback: Container(
            width: widget.parameters.axis == Axis.vertical
                ? (widget.parameters.listDraggingWidth ??
                    MediaQuery.of(context).size.width)
                : (widget.parameters.listDraggingWidth ??
                    widget.parameters.listWidth),
            child: Material(
              child: dragAndDropListContents,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
          onDragStarted: () => _setDragging(true),
          onDragCompleted: () => _setDragging(false),
          onDraggableCanceled: (_, __) => _setDragging(false),
          onDragEnd: (_) => _setDragging(false),
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
        onPointerMove: _onPointerMove,
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
              bool accept = true;
              if (widget.parameters.listOnWillAccept != null) {
                accept = widget.parameters
                    .listOnWillAccept(incoming, widget.dragAndDropList);
              }
              if (accept) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
              }
              return accept;
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

  void _setDragging(bool dragging) {
    if (_dragging != dragging) {
      setState(() {
        _dragging = dragging;
      });
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragging) widget.parameters.onPointerMove(event);
  }
}
