import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemTargetInternal extends StatefulWidget {
  final Widget child;
  final DragAndDropList parent;
  final Function(DragAndDropItem newOrReorderedItem, DragAndDropList receiverList) onItemDropOnLastTarget;
  final int sizeAnimationDuration;
  final Widget ghost;
  final double ghostOpacity;

  DragAndDropItemTargetInternal(
      {@required this.child,
      @required this.parent,
      @required this.onItemDropOnLastTarget,
      this.sizeAnimationDuration = 150,
      this.ghostOpacity = 0.3,
      this.ghost,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemTargetInternal();
}

class _DragAndDropItemTargetInternal extends State<DragAndDropItemTargetInternal> with TickerProviderStateMixin {
  DragAndDropItem _hoveredDraggable;

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
            widget.child ??
                Container(
                  height: 20,
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
                widget.onItemDropOnLastTarget(incoming, widget.parent);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
