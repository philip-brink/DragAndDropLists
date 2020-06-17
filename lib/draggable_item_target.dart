import 'package:drag_and_drop_lists/draggable_item.dart';
import 'package:drag_and_drop_lists/draggable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableItemTarget extends StatefulWidget {
  final Widget target;
  final int sizeAnimationDuration;
  final Widget ghost;
  final double ghostOpacity;
  final DraggableList parentList;
  final int id;
  final Function(DraggableItem reordered, DraggableItemTarget receiver) onReorderOrAdd;

  DraggableItemTarget(
      {this.target,
      this.parentList,
      @required this.sizeAnimationDuration,
      this.ghost,
      @required this.ghostOpacity,
      this.onReorderOrAdd,
      this.id,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableItemTarget();
}

class _DraggableItemTarget extends State<DraggableItemTarget> with TickerProviderStateMixin {
  DraggableItem _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: widget.sizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.ghostOpacity,
                      child: widget.ghost ?? _hoveredDraggable.child,
                    )
                  : Container(),
            ),
            widget.target ??
                Container(
                  height: 20,
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
                if (widget.onReorderOrAdd != null) widget.onReorderOrAdd(incoming, widget);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
