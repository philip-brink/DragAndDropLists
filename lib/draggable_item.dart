import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableItem extends StatefulWidget {
  final Widget child;
  final Widget ghost;
  final double draggingWidth;
  final double ghostOpacity;
  final int sizeAnimationDuration;
  final bool dragOnLongPress;
  final int id;
  final bool canDrag;
  final bool isEmptyItem;
  final CrossAxisAlignment verticalAlignment;
  final Function(DraggableItem reordered, DraggableItem receiver) onReorder;
  final Function(PointerMoveEvent event) onPointerMove;
  final Function(PointerDownEvent event) onPointerDown;
  final Function(PointerUpEvent event) onPointerUp;

  DraggableItem(
      {@required this.child,
      this.ghost,
      this.draggingWidth,
      this.ghostOpacity = 0.3,
      this.sizeAnimationDuration = 300,
      this.canDrag = true,
      this.isEmptyItem = false,
      this.dragOnLongPress,
      @required this.onReorder,
      this.onPointerMove,
      this.onPointerDown,
      this.onPointerUp,
      this.verticalAlignment,
      this.id,
      Key key})
      : super(key: key);

  DraggableItem.emptyItem(
      {@required this.child,
      this.ghost,
      this.ghostOpacity = 0.3,
      this.sizeAnimationDuration = 300,
      this.canDrag = false,
      this.isEmptyItem = true,
      this.dragOnLongPress,
      this.draggingWidth,
      @required this.onReorder,
      this.onPointerMove,
      this.onPointerDown,
      this.onPointerUp,
      this.verticalAlignment,
      this.id,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableItem();
}

class _DraggableItem extends State<DraggableItem> with TickerProviderStateMixin {
  DraggableItem _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    Widget draggable;
    if (widget.canDrag) {
      if (widget.dragOnLongPress) {
        draggable = LongPressDraggable<DraggableItem>(
          data: widget,
          axis: Axis.vertical,
          child: widget.child,
          feedback: Container(
            width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
            child: Material(
              child: widget.child,
              color: Colors.transparent,
            ),
          ),
          childWhenDragging: Container(),
        );
      } else {
        draggable = Draggable<DraggableItem>(
          data: widget,
          axis: Axis.vertical,
          child: widget.child,
          feedback: Container(
            width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
            child: Material(
              child: widget.child,
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
        child: _hoveredDraggable != null ? Container() : widget.child,
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
          child: DragTarget<DraggableItem>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData != null && candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              if (incoming != widget) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
                return true;
              }
              return false;
            },
            onLeave: (incoming) {
              setState(() {
                _hoveredDraggable = null;
              });
            },
            onAccept: (incoming) {
              setState(() {
                if (widget.onReorder != null) widget.onReorder(incoming, widget);
                _hoveredDraggable = null;
              });
            },
          ),
        )
      ],
    );
  }
}
