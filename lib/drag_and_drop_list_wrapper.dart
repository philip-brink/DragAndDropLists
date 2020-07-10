import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropListWrapper extends StatefulWidget {
  final DragAndDropListInterface dragAndDropList;
  final DragAndDropBuilderParameters parameters;

  DragAndDropListWrapper({this.dragAndDropList, this.parameters, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListWrapper();
}

class _DragAndDropListWrapper extends State<DragAndDropListWrapper> with TickerProviderStateMixin {
  DragAndDropListInterface _hoveredDraggable;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dragAndDropListContents = widget.dragAndDropList.generateWidget(widget.parameters);

    Widget draggable;
    if (widget.parameters.dragOnLongPress) {
      draggable = LongPressDraggable<DragAndDropListInterface>(
        data: widget.dragAndDropList,
        axis: widget.parameters.axis,
        child: dragAndDropListContents,
        feedback: Container(
          width: widget.parameters.draggingWidth ?? MediaQuery.of(context).size.width,
          child: Material(
            child: dragAndDropListContents,
            color: Colors.transparent,
          ),
        ),
        childWhenDragging: Container(),
      );
    } else {
      draggable = Draggable<DragAndDropListInterface>(
        data: widget.dragAndDropList,
        axis: widget.parameters.axis,
        child: dragAndDropListContents,
        // TODO: This width for horizontal dragging isn't functioning properly when no draggingWidth set
        feedback: Container(
          width: widget.parameters.axis == Axis.vertical
              ? (widget.parameters.draggingWidth ?? MediaQuery.of(context).size.width)
              : (widget.parameters.draggingWidth ?? widget.parameters.listWidth),
          child: Material(
            child: dragAndDropListContents,
            color: Colors.transparent,
          ),
        ),
        childWhenDragging: Container(),
      );
    }

    var rowOrColumnChildren = <Widget>[
      AnimatedSize(
        duration: Duration(milliseconds: widget.parameters.listSizeAnimationDuration),
        vsync: this,
        alignment: widget.parameters.axis == Axis.vertical ? Alignment.bottomCenter : Alignment.topLeft,
        child: _hoveredDraggable != null
            ? Opacity(
                opacity: widget.parameters.listGhostOpacity,
                child: widget.parameters.listGhost ??
                    Container(
                      padding: widget.parameters.axis == Axis.vertical
                          ? EdgeInsets.all(0)
                          : EdgeInsets.symmetric(horizontal: widget.parameters.listPadding.horizontal),
                      child: _hoveredDraggable.generateWidget(widget.parameters),
                    ),
              )
            : Container(),
      ),
      Listener(
        child: draggable,
        onPointerMove: widget.parameters.onPointerMove,
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
                children: rowOrColumnChildren,
              ),
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
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
              if (_hoveredDraggable != null) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
            },
            onAccept: (incoming) {
              setState(() {
                widget.parameters.onListReordered(incoming, widget.dragAndDropList);
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
}
