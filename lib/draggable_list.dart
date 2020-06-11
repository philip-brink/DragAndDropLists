import 'package:drag_and_drop_lists/draggable_list_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableList extends StatefulWidget {
  final double draggingWidth;
  final int sizeAnimationDuration;
  final double ghostOpacity;
  final bool dragOnLongPress;
  final EdgeInsets padding;
  final DraggableListContents draggableListContents;
  final int id;
  final Function(DraggableList reordered, DraggableList receiver, bool placedBeforeReceiver) onReorder;
  final Function(PointerMoveEvent event) onPointerMove;
  final Function(PointerDownEvent event) onPointerDown;
  final Function(PointerUpEvent event) onPointerUp;

  DraggableList(
      {this.draggingWidth,
      this.sizeAnimationDuration,
      this.ghostOpacity,
      this.dragOnLongPress,
      this.onReorder,
      this.onPointerMove,
      this.onPointerDown,
      this.onPointerUp,
      this.padding,
      this.draggableListContents,
      this.id,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableContainer();
}

class _DraggableContainer extends State<DraggableList> with TickerProviderStateMixin {
  DraggableList _hoveredDraggableAbove;
  DraggableList _hoveredDraggableBelow;

  @override
  Widget build(BuildContext context) {
    Widget draggable;
    if (widget.dragOnLongPress) {
      draggable = LongPressDraggable<DraggableList>(
        data: widget,
        axis: Axis.vertical,
        child: widget.draggableListContents,
        feedback: Container(
          width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
          child: Material(
            child: widget.draggableListContents,
            color: Colors.transparent,
          ),
        ),
        childWhenDragging: Container(),
      );
    } else {
      draggable = Draggable<DraggableList>(
        data: widget,
        axis: Axis.vertical,
        child: widget.draggableListContents,
        feedback: Container(
          width: widget.draggingWidth ?? MediaQuery.of(context).size.width,
          child: Material(
            child: widget.draggableListContents,
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
              duration: (_hoveredDraggableAbove == null && _hoveredDraggableBelow == null)
                  ? Duration(milliseconds: 1)
                  : Duration(milliseconds: widget.sizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggableAbove != null
                  ? Opacity(
                      opacity: widget.ghostOpacity,
                      child: _hoveredDraggableAbove.draggableListContents,
                    )
                  : Container(),
            ),
            Listener(
              child: draggable,
              onPointerMove: widget.onPointerMove,
              onPointerDown: widget.onPointerDown,
              onPointerUp: widget.onPointerUp,
            ),
            AnimatedSize(
              duration: (_hoveredDraggableAbove == null && _hoveredDraggableBelow == null)
                  ? Duration(milliseconds: 1)
                  : Duration(milliseconds: widget.sizeAnimationDuration),
              vsync: this,
              alignment: Alignment.topCenter,
              child: _hoveredDraggableBelow != null
                  ? Opacity(
                      opacity: widget.ghostOpacity,
                      child: _hoveredDraggableBelow.draggableListContents,
                    )
                  : Container(),
            ),
          ],
        ),
        Positioned.fill(
          child: Column(
            children: <Widget>[
              Expanded(
                child: DragTarget<DraggableList>(
                  builder: (context, candidateData, rejectedData) {
                    if (candidateData != null && candidateData.isNotEmpty) {}
                    return Container();
                  },
                  onWillAccept: (incoming) {
                    if (incoming != widget) {
                      setState(() {
                        _hoveredDraggableAbove = incoming;
                      });
                      return true;
                    }
                    return false;
                  },
                  onLeave: (incoming) {
                    setState(() {
                      _hoveredDraggableAbove = null;
                    });
                  },
                  onAccept: (incoming) {
                    setState(() {
                      if (widget.onReorder != null) widget.onReorder(incoming, widget, true);
                      _hoveredDraggableAbove = null;
                    });
                  },
                ),
              ),
              Expanded(
                child: DragTarget<DraggableList>(
                  builder: (context, candidateData, rejectedData) {
                    if (candidateData != null && candidateData.isNotEmpty) {}
                    return Container();
                  },
                  onWillAccept: (incoming) {
                    if (incoming != widget) {
                      setState(() {
                        _hoveredDraggableBelow = incoming;
                      });
                      return true;
                    }
                    return false;
                  },
                  onLeave: (incoming) {
                    setState(() {
                      _hoveredDraggableBelow = null;
                    });
                  },
                  onAccept: (incoming) {
                    if (widget.onReorder != null) widget.onReorder(incoming, widget, false);
                    setState(() {
                      _hoveredDraggableBelow = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
    if (widget.padding != null) {
      return Padding(
        padding: widget.padding,
        child: stack,
      );
    } else {
      return stack;
    }
  }
}
