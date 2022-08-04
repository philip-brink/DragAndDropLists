import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:drag_and_drop_lists/measure_size.dart';
import 'package:flutter/material.dart';

class DragAndDropItemWrapper extends StatefulWidget {
  final DragAndDropItem child;
  final DragAndDropBuilderParameters? parameters;

  DragAndDropItemWrapper(
      {required this.child, required this.parameters, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemWrapper();
}

class _DragAndDropItemWrapper extends State<DragAndDropItemWrapper>
    with TickerProviderStateMixin {
  DragAndDropItem? _hoveredDraggable;

  bool _dragging = false;
  Size _containerSize = Size.zero;
  Size _dragHandleSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    Widget draggable;
    if (widget.child.canDrag) {
      if (widget.parameters!.itemDragHandle != null) {
        Widget feedback = Container(
          width: widget.parameters!.itemDraggingWidth ?? _containerSize.width,
          child: Stack(
            children: [
              widget.child.child,
              Positioned(
                right: widget.parameters!.itemDragHandle!.onLeft ? null : 0,
                left: widget.parameters!.itemDragHandle!.onLeft ? 0 : null,
                top: widget.parameters!.itemDragHandle!.verticalAlignment ==
                        DragHandleVerticalAlignment.bottom
                    ? null
                    : 0,
                bottom: widget.parameters!.itemDragHandle!.verticalAlignment ==
                        DragHandleVerticalAlignment.top
                    ? null
                    : 0,
                child: widget.parameters!.itemDragHandle!,
              ),
            ],
          ),
        );

        var positionedDragHandle = Positioned(
          right: widget.parameters!.itemDragHandle!.onLeft ? null : 0,
          left: widget.parameters!.itemDragHandle!.onLeft ? 0 : null,
          top: widget.parameters!.itemDragHandle!.verticalAlignment ==
                  DragHandleVerticalAlignment.bottom
              ? null
              : 0,
          bottom: widget.parameters!.itemDragHandle!.verticalAlignment ==
                  DragHandleVerticalAlignment.top
              ? null
              : 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Draggable<DragAndDropItem>(
              data: widget.child,
              axis: widget.parameters!.axis == Axis.vertical &&
                      widget.parameters!.constrainDraggingAxis
                  ? Axis.vertical
                  : null,
              child: MeasureSize(
                onSizeChange: (size) {
                  setState(() {
                    _dragHandleSize = size!;
                  });
                },
                child: widget.parameters!.itemDragHandle,
              ),
              feedback: Transform.translate(
                offset: _feedbackContainerOffset(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: widget.parameters!.itemDecorationWhileDragging,
                    child: Directionality(
                      textDirection: Directionality.of(context),
                      child: feedback,
                    ),
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
      } else if (widget.parameters!.dragOnLongPress) {
        draggable = MeasureSize(
          onSizeChange: _setContainerSize,
          child: LongPressDraggable<DragAndDropItem>(
            data: widget.child,
            axis: widget.parameters!.axis == Axis.vertical &&
                    widget.parameters!.constrainDraggingAxis
                ? Axis.vertical
                : null,
            child: widget.child.child,
            feedback: Container(
              width:
                  widget.parameters!.itemDraggingWidth ?? _containerSize.width,
              child: Material(
                child: Container(
                  child: Directionality(
                      textDirection: Directionality.of(context),
                      child: widget.child.feedbackWidget ?? widget.child.child),
                  decoration: widget.parameters!.itemDecorationWhileDragging,
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
            axis: widget.parameters!.axis == Axis.vertical &&
                    widget.parameters!.constrainDraggingAxis
                ? Axis.vertical
                : null,
            child: widget.child.child,
            feedback: Container(
              width:
                  widget.parameters!.itemDraggingWidth ?? _containerSize.width,
              child: Material(
                child: Container(
                  child: Directionality(
                    textDirection: Directionality.of(context),
                    child: widget.child.feedbackWidget ?? widget.child.child,
                  ),
                  decoration: widget.parameters!.itemDecorationWhileDragging,
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
        duration: Duration(
            milliseconds: widget.parameters!.itemSizeAnimationDuration),
        alignment: Alignment.bottomCenter,
        child: _hoveredDraggable != null ? Container() : widget.child.child,
      );
    }
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.parameters!.verticalAlignment,
          children: <Widget>[
            AnimatedSize(
              duration: Duration(
                  milliseconds: widget.parameters!.itemSizeAnimationDuration),
              alignment: Alignment.topLeft,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters!.itemGhostOpacity,
                      child: widget.parameters!.itemGhost ??
                          _hoveredDraggable!.child,
                    )
                  : Container(),
            ),
            Listener(
              child: draggable,
              onPointerMove: _onPointerMove,
              onPointerDown: widget.parameters!.onPointerDown,
              onPointerUp: widget.parameters!.onPointerUp,
            ),
          ],
        ),
        Positioned.fill(
          child: DragTarget<DragAndDropItem>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              bool accept = true;
              if (widget.parameters!.itemOnWillAccept != null)
                accept = widget.parameters!.itemOnWillAccept!(
                    incoming, widget.child);
              if (accept && mounted) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
              }
              return accept;
            },
            onLeave: (incoming) {
              if (mounted) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
            },
            onAccept: (incoming) {
              if (mounted) {
                setState(() {
                  if (widget.parameters!.onItemReordered != null)
                    widget.parameters!.onItemReordered!(incoming, widget.child);
                  _hoveredDraggable = null;
                });
              }
            },
          ),
        )
      ],
    );
  }

  Offset _feedbackContainerOffset() {
    double xOffset;
    double yOffset;
    if (widget.parameters!.itemDragHandle!.onLeft) {
      xOffset = 0;
    } else {
      xOffset = -_containerSize.width + _dragHandleSize.width;
    }
    if (widget.parameters!.itemDragHandle!.verticalAlignment ==
        DragHandleVerticalAlignment.bottom) {
      yOffset = -_containerSize.height + _dragHandleSize.width;
    } else {
      yOffset = 0;
    }

    return Offset(xOffset, yOffset);
  }

  void _setContainerSize(Size? size) {
    if (mounted) {
      setState(() {
        _containerSize = size!;
      });
    }
  }

  void _setDragging(bool dragging) {
    if (_dragging != dragging && mounted) {
      setState(() {
        _dragging = dragging;
      });
      if (widget.parameters!.onItemDraggingChanged != null) {
        widget.parameters!.onItemDraggingChanged!(widget.child, dragging);
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragging) widget.parameters!.onPointerMove!(event);
  }
}
