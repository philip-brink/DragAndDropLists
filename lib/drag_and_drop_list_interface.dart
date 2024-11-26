import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:flutter/material.dart';

abstract class DragAndDropListInterface implements DragAndDropInterface {
  List<DragAndDropItem>? get children;

  /// Whether or not this item can be dragged.
  /// Set to true if it can be reordered.
  /// Set to false if it must remain fixed.
  bool get canDrag;
  Key? get key;
  Widget generateWidget(DragAndDropBuilderParameters params);
}

abstract class DragAndDropListExpansionInterface
    implements DragAndDropListInterface {
  @override
  final List<DragAndDropItem>? children;

  DragAndDropListExpansionInterface({this.children});

  get isExpanded;

  toggleExpanded();

  expand();

  collapse();
}
