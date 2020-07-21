import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemWrapper extends StatefulWidget {
  final DragAndDropItem child;
  final Function(PointerMoveEvent event) onPointerMove;
  final Function(PointerUpEvent event) onPointerUp;
  final Function(PointerDownEvent event) onPointerDown;
  final Function(DragAndDropItem reorderedItem, DragAndDropItem receiverItem)
      onItemReordered;
  final Widget ghost;
  final double draggingWidth;
  final double ghostOpacity;
  final int sizeAnimationDuration;
  final bool dragOnLongPress;
  final CrossAxisAlignment verticalAlignment;
  final Axis axis;

  DragAndDropItemWrapper(
      {@required this.child,
      @required this.onPointerMove,
      @required this.onPointerUp,
      @required this.onPointerDown,
      @required this.onItemReordered,
      this.ghost,
      this.draggingWidth,
      this.ghostOpacity = 0.3,
      this.sizeAnimationDuration = 300,
      this.dragOnLongPress = true,
      this.verticalAlignment = CrossAxisAlignment.start,
      this.axis = Axis.vertical,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemWrapper();
}

class _DragAndDropItemWrapper extends State<DragAndDropItemWrapper>
    with TickerProviderStateMixin {
  DragAndDropItem _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    Widget draggable;
    if (widget.child.canDrag) {
      if (widget.dragOnLongPress) {
        draggable = LongPressDraggable<DragAndDropItem>(
          data: widget.child,
          axis: widget.axis == Axis.vertical ? Axis.vertical : null,
          child: widget.child.child,
          feedback: Container(
            width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
            child: Material(
              child: widget.child.child,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
        );
      } else {
        draggable = Draggable<DragAndDropItem>(
          data: widget.child,
          axis: widget.axis == Axis.vertical ? Axis.vertical : null,
          child: widget.child.child,
          feedback: Container(
            width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
            child: Material(
              child: widget.child.child,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
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
              onPointerMove: widget.onPointerMove,
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
}
