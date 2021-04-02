import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemTarget extends StatefulWidget {
  final Widget child;
  final DragAndDropListInterface? parent;
  final OnItemDropOnLastTarget onReorderOrAdd;
  final CrossAxisAlignment verticalAlignment;
  final int itemSizeAnimationDuration;
  final Widget? itemGhost;
  final double itemGhostOpacity;
  final ItemTargetOnWillAccept? itemTargetOnWillAccept;

  DragAndDropItemTarget(
      {required this.child,
      required this.onReorderOrAdd,
      this.itemTargetOnWillAccept,
      this.parent,
      this.verticalAlignment = CrossAxisAlignment.start,
      this.itemSizeAnimationDuration = 150,
      this.itemGhost,
      this.itemGhostOpacity = 0.3,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropItemTarget();
}

class _DragAndDropItemTarget extends State<DragAndDropItemTarget>
    with TickerProviderStateMixin {
  DragAndDropItem? _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: widget.verticalAlignment,
          children: <Widget>[
            AnimatedSize(
              duration:
                  Duration(milliseconds: widget.itemSizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.itemGhostOpacity,
                      child: widget.itemGhost ?? _hoveredDraggable!.child,
                    )
                  : Container(),
            ),
            widget.child,
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
              if (widget.itemTargetOnWillAccept != null)
                accept = widget.itemTargetOnWillAccept!(incoming, widget);
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
                  widget.onReorderOrAdd(incoming, widget.parent!, widget);
                  _hoveredDraggable = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
