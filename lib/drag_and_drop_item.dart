import 'package:drag_and_drop_lists/drag_and_drop_interface.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItem implements DragAndDropInterface {
  final Widget child;
  final bool canDrag;

  DragAndDropItem({@required this.child, this.canDrag = true});
}
