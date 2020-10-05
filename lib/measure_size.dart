import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef void OnWidgetSizeChange(Size size);
typedef void OnWidgetLeftPositionChange(double leftPosition);

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onSizeChange;
  final OnWidgetLeftPositionChange onLeftPositionChange;

  const MeasureSize({
    Key key,
    @required this.onSizeChange,
    @required this.onLeftPositionChange,
    @required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;
  var leftPosition = 0.0;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize != newSize) {
      widget.onSizeChange(newSize);
      oldSize = newSize;
    }

    RenderBox rb = context.findRenderObject();
    if (rb == null) return;

    var newLeftPosition = rb.localToGlobal(Offset.zero).dx;
    if (newLeftPosition != leftPosition) {
      widget.onLeftPositionChange(newLeftPosition);
      leftPosition = newLeftPosition;
    }
  }
}
