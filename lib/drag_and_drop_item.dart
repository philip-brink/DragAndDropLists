import 'package:flutter/widgets.dart';

class DragAndDropItem {
  final Widget child;
  final bool canDrag;

  DragAndDropItem({@required this.child, this.canDrag = true});
}
