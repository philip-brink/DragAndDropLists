import 'package:drag_and_drop_lists/drag_and_drop_interface.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItem implements DragAndDropInterface {
  /// The child widget of this item.
  final Widget child;

  /// Whether or not this item can be dragged.
  /// Set to true if it can be reordered.
  /// Set to false if it must remain fixed.
  final bool canDrag;

  DragAndDropItem({required this.child, this.canDrag = true});
}
