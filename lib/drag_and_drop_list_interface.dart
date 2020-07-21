import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:flutter/material.dart';

abstract class DragAndDropListInterface implements DragAndDropInterface {
  final List<DragAndDropItem> children;

  DragAndDropListInterface({this.children});

  Widget generateWidget(DragAndDropBuilderParameters params);
}

abstract class DragAndDropListExpansionInterface
    implements DragAndDropListInterface {
  final List<DragAndDropItem> children;

  DragAndDropListExpansionInterface({this.children});

  get isExpanded;

  toggleExpanded();

  expand();

  collapse();
}
