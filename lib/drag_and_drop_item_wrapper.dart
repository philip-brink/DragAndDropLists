import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:drag_and_drop_lists/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemWrapper extends StatefulWidget {
  final DragAndDropItem child;
  final OnPointerMove onPointerMove;
  final OnPointerUp onPointerUp;
  final OnPointerDown onPointerDown;
  final OnItemReordered onItemReordered;
  final ItemOnWillAccept itemOnWillAccept;
  final Widget ghost;
  final double draggingWidth;
  final double ghostOpacity;
  final int sizeAnimationDuration;
  final bool dragOnLongPress;
  final CrossAxisAlignment verticalAlignment;
  final Axis axis;
  final Decoration decorationWhileDragging;
  final DragHandleVerticalAlignment dragHandleVerticalAlignment;
  final bool constrainDraggingAxis;

  /// Set a custom drag handle to use iOS-like handles to drag rather than long
  /// or short presses
  final Widget dragHandle;
  final bool dragHandleOnLeft;

  DragAndDropItemWrapper(
      {@required this.child,
      @required this.onPointerMove,
      @required this.onPointerUp,
      @required this.onPointerDown,
      @required this.onItemReordered,
      this.itemOnWillAccept,
      this.ghost,
      this.draggingWidth,
      this.ghostOpacity = 0.3,
      this.sizeAnimationDuration = 300,
      this.dragOnLongPress = true,
      this.verticalAlignment = CrossAxisAlignment.start,
      this.axis = Axis.vertical,
      this.dragHandle,
      this.dragHandleOnLeft = false,
      this.decorationWhileDragging,
      this.dragHandleVerticalAlignment,
      this.constrainDraggingAxis = true,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemWrapper();
}

class _DragAndDropItemWrapper extends State<DragAndDropItemWrapper>
    with TickerProviderStateMixin {
  DragAndDropItem _hoveredDraggable;

  bool _dragging = false;
  Size _containerSize = Size.zero;
  Size _dragHandleSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    Widget draggable;
    if (widget.child.canDrag) {
      if (widget.dragHandle != null) {
        Widget feedback = Container(
          width: widget.draggingWidth ?? _containerSize.width,
          child: Stack(
            children: [
              widget.child.child,
              Positioned(
                right: widget.dragHandleOnLeft ? null : 0,
                left: widget.dragHandleOnLeft ? 0 : null,
                top: widget.dragHandleVerticalAlignment ==
                        DragHandleVerticalAlignment.bottom
                    ? null
                    : 0,
                bottom: widget.dragHandleVerticalAlignment ==
                        DragHandleVerticalAlignment.top
                    ? null
                    : 0,
                child: widget.dragHandle,
              ),
            ],
          ),
        );

        var positionedDragHandle = Positioned(
          right: widget.dragHandleOnLeft ? null : 0,
          left: widget.dragHandleOnLeft ? 0 : null,
          top: widget.dragHandleVerticalAlignment ==
                  DragHandleVerticalAlignment.bottom
              ? null
              : 0,
          bottom: widget.dragHandleVerticalAlignment ==
                  DragHandleVerticalAlignment.top
              ? null
              : 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Draggable<DragAndDropItem>(
              data: widget.child,
              axis: widget.axis == Axis.vertical && widget.constrainDraggingAxis
                  ? Axis.vertical
                  : null,
              child: MeasureSize(
                onSizeChange: (size) {
                  setState(() {
                    _dragHandleSize = size;
                  });
                },
                child: widget.dragHandle,
              ),
              feedback: Transform.translate(
                offset: _feedbackContainerOffset(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: widget.decorationWhileDragging,
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
        );

        draggable = MeasureSize(
          onSizeChange: _setContainerSize,
          child: Stack(
            children: [
              Visibility(
                visible: !_dragging,
                child: widget.child.child,
              ),
              // dragAndDropListContents,
              positionedDragHandle,
            ],
          ),
        );
      } else if (widget.dragOnLongPress) {
        draggable = MeasureSize(
          onSizeChange: _setContainerSize,
          child: LongPressDraggable<DragAndDropItem>(
            data: widget.child,
            axis: widget.axis == Axis.vertical && widget.constrainDraggingAxis
                ? Axis.vertical
                : null,
            child: widget.child.child,
            feedback: Container(
              width: widget.draggingWidth ?? _containerSize.width,
              child: Material(
                child: Container(
                  child: widget.child.child,
                  decoration: widget.decorationWhileDragging,
                ),
                color: Colors.transparent,
              ),
            ),
            childWhenDragging: Container(),
            onDragStarted: () => _setDragging(true),
            onDragCompleted: () => _setDragging(false),
            onDraggableCanceled: (_, __) => _setDragging(false),
            onDragEnd: (_) => _setDragging(false),
          ),
        );
      } else {
        draggable = MeasureSize(
          onSizeChange: _setContainerSize,
          child: Draggable<DragAndDropItem>(
            data: widget.child,
            axis: widget.axis == Axis.vertical && widget.constrainDraggingAxis
                ? Axis.vertical
                : null,
            child: widget.child.child,
            feedback: Container(
              width: widget.draggingWidth ?? _containerSize.width,
              child: Material(
                child: Container(
                  child: widget.child.child,
                  decoration: widget.decorationWhileDragging,
                ),
                color: Colors.transparent,
              ),
            ),
            childWhenDragging: Container(),
            onDragStarted: () => _setDragging(true),
            onDragCompleted: () => _setDragging(false),
            onDraggableCanceled: (_, __) => _setDragging(false),
            onDragEnd: (_) => _setDragging(false),
          ),
        );
      }
    } else {
      draggable = AnimatedSize(
        duration: Duration(milliseconds: widget.sizeAnimationDuration),
        vsync: this,
        alignment: Alignment.bottomCenter,
        child: _hoveredDraggable != null ? Container() : widget.child.child,
      );
    }
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.verticalAlignment,
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: widget.sizeAnimationDuration),
              vsync: this,
              alignment: Alignment.topLeft,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.ghostOpacity,
                      child: widget.ghost ?? _hoveredDraggable.child,
                    )
                  : Container(),
            ),
            Listener(
              child: draggable,
              onPointerMove: _onPointerMove,
              onPointerDown: widget.onPointerDown,
              onPointerUp: widget.onPointerUp,
            ),
          ],
        ),
        Positioned.fill(
          child: DragTarget<DragAndDropItem>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData != null && candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              bool accept = true;
              if (widget.itemOnWillAccept != null)
                accept = widget.itemOnWillAccept(incoming, widget.child);
              if (accept) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
              }
              return accept;
            },
            onLeave: (incoming) {
              setState(() {
                _hoveredDraggable = null;
              });
            },
            onAccept: (incoming) {
              setState(() {
                if (widget.onItemReordered != null)
                  widget.onItemReordered(incoming, widget.child);
                _hoveredDraggable = null;
              });
            },
          ),
        )
      ],
    );
  }

  Offset _feedbackContainerOffset() {
    double xOffset;
    double yOffset;
    if (widget.dragHandleOnLeft) {
      xOffset = 0;
    } else {
      xOffset = -_containerSize.width + _dragHandleSize.width;
    }
    if (widget.dragHandleVerticalAlignment ==
        DragHandleVerticalAlignment.bottom) {
      yOffset = -_containerSize.height + _dragHandleSize.width;
    } else {
      yOffset = 0;
    }

    return Offset(xOffset, yOffset);
  }

  void _setContainerSize(Size size) {
    if (mounted) {
      setState(() {
        _containerSize = size;
      });
    }
  }

  void _setDragging(bool dragging) {
    if (_dragging != dragging && mounted) {
      setState(() {
        _dragging = dragging;
      });
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragging) widget.onPointerMove(event);
  }
}
