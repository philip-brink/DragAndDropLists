import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemTarget extends StatefulWidget {
  final Widget child;
  final DragAndDropListInterface parent;
  final DragAndDropBuilderParameters parameters;
  final Function(DragAndDropItem reordered, DragAndDropListInterface parentList,
      DragAndDropItemTarget receiver) onReorderOrAdd;

  DragAndDropItemTarget(
      {@required this.child,
      @required this.onReorderOrAdd,
      @required this.parameters,
      this.parent,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemTarget();
}

class _DragAndDropItemTarget extends State<DragAndDropItemTarget>
    with TickerProviderStateMixin {
  DragAndDropItem _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: widget.parameters.verticalAlignment,
          children: <Widget>[
            AnimatedSize(
              duration: Duration(
                  milliseconds: widget.parameters.itemSizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters.itemGhostOpacity,
                      child: widget.parameters.itemGhost ??
                          _hoveredDraggable.child,
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
                if (widget.onReorderOrAdd != null)
                  widget.onReorderOrAdd(incoming, widget.parent, widget);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
