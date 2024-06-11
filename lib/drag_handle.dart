import 'package:flutter/widgets.dart';

enum DragHandleVerticalAlignment {
  top,
  center,
  bottom,
}

class DragHandle extends StatelessWidget {
  /// Set the drag handle to be on the left side instead of the default right side
  final bool onLeft;

  /// Align the list drag handle to the top, center, or bottom
  final DragHandleVerticalAlignment verticalAlignment;

  /// Child widget to displaying the drag handle
  final Widget child;

  const DragHandle({
    super.key,
    required this.child,
    this.onLeft = false,
    this.verticalAlignment = DragHandleVerticalAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
