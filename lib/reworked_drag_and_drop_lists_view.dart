// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:drag_and_drop_lists/reworked_drag_and_drop_lists.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A list whose lists the user can interactively reorder by dragging.
///
/// This class is appropriate for views with a small number of
/// children because constructing the [List] requires doing work for every
/// child that could possibly be displayed in the list view instead of just
/// those children that are actually visible.
///
/// All list lists must have a key.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=3fB1mxOsqJE}
///
/// This sample shows by dragging the user can reorder the lists of the list.
/// The [onReorder] parameter is required and will be called when a child
/// widget is dragged to a new position.
///
/// {@tool dartpad --template=stateful_widget_scaffold}
///
/// ```dart
/// final List<int> _lists = List<int>.generate(50, (int index) => index);
///
/// Widget build(BuildContext context){
///   final ColorScheme colorScheme = Theme.of(context).colorScheme;
///   final oddListColor = colorScheme.primary.withOpacity(0.05);
///   final evenListColor = colorScheme.primary.withOpacity(0.15);
///
///   return ReworkedDragAndDropListsView(
///     padding: const EdgeInsets.symmetric(horizontal: 40),
///     children: <Widget>[
///       for (int index = 0; index < _lists.length; index++)
///         ListTile(
///           key: Key('$index'),
///           tileColor: _lists[index].isOdd ? oddListColor : evenListColor,
///           title: Text('List ${_lists[index]}'),
///         ),
///     ],
///     onReorder: (int oldIndex, int newIndex) {
///       setState(() {
///         if (oldIndex < newIndex) {
///           newIndex -= 1;
///         }
///         final int list = _lists.removeAt(oldIndex);
///         _lists.insert(newIndex, list);
///       });
///     },
///   );
/// }
///
/// ```
///
///{@end-tool}
class ReworkedDragAndDropListsView extends StatefulWidget {
  /// Creates a reorderable list from a pre-built list of widgets.
  ///
  /// See also:
  ///
  ///   * [ReworkedDragAndDropListsView.builder], which allows you to build a reorderable
  ///     list where the lists are built as needed when scrolling the list.
  ReworkedDragAndDropListsView({
    Key? key,
    required List<Widget> children,
    required this.onReorder,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding = EdgeInsets.zero,
    this.header,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : assert(
          children.every((Widget w) => w.key != null),
          'All children of this widget must have a key.',
        ),
        listBuilder = ((BuildContext context, int index) => children[index]),
        listCount = children.length,
        super(key: key);

  /// Creates a reorderable list from widget lists that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large number of
  /// children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// The `listBuilder` callback will be called only with indices greater than
  /// or equal to zero and less than `listCount`.
  ///
  /// The `listBuilder` should always return a non-null widget, and actually
  /// create the widget instances when called. Avoid using a builder that
  /// returns a previously-constructed widget; if the list view's children are
  /// created in advance, or all at once when the [ReworkedDragAndDropListsView] itself
  /// is created, it is more efficient to use the [ReworkedDragAndDropListsView]
  /// constructor. Even more efficient, however, is to create the instances
  /// on demand using this constructor's `listBuilder` callback.
  ///
  /// See also:
  ///
  ///   * [ReworkedDragAndDropListsView], which allows you to build a reorderable
  ///     list with all the lists passed into the constructor.
  const ReworkedDragAndDropListsView.builder({
    Key? key,
    required this.listBuilder,
    required this.listCount,
    required this.onReorder,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding = EdgeInsets.zero,
    this.header,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  /// {@macro flutter.widgets.reorderable_list.listBuilder}
  final IndexedWidgetBuilder listBuilder;

  /// {@macro flutter.widgets.reorderable_list.listCount}
  final int listCount;

  /// {@macro flutter.widgets.reorderable_list.onReorder}
  final ReorderCallback onReorder;

  /// {@macro flutter.widgets.reorderable_list.proxyDecorator}
  final ReorderItemProxyDecorator? proxyDecorator;

  /// If true: on desktop platforms, a drag handle is stacked over the
  /// center of each list's trailing edge; on mobile platforms, a long
  /// press anywhere on the list starts a drag.
  ///
  /// The default desktop drag handle is just an [Icons.drag_handle]
  /// wrapped by a [ReorderableDragStartListener]. On mobile
  /// platforms, the entire list is wrapped with a
  /// [ReorderableDelayedDragStartListener].
  ///
  /// To change the appearance or the layout of the drag handles, make
  /// this parameter false and wrap each list list, or a widget within
  /// each list list, with [ReorderableDragStartListener] or
  /// [ReorderableDelayedDragStartListener], or a custom subclass
  /// of [ReorderableDragStartListener].
  ///
  /// The following sample specifies `buildDefaultDragHandles: false`, and
  /// uses a [Card] at the leading edge of each list for the list's drag handle.
  ///
  /// {@tool dartpad --template=stateful_widget_scaffold}
  ///
  /// ```dart
  /// final List<int> _lists = List<int>.generate(50, (int index) => index);
  ///
  /// Widget build(BuildContext context){
  ///   final ColorScheme colorScheme = Theme.of(context).colorScheme;
  ///   final oddListColor = colorScheme.primary.withOpacity(0.05);
  ///   final evenListColor = colorScheme.primary.withOpacity(0.15);
  ///
  ///   return ReworkedDragAndDropListsView(
  ///     buildDefaultDragHandles: false,
  ///     children: <Widget>[
  ///       for (int index = 0; index < _lists.length; index++)
  ///         Container(
  ///           key: Key('$index'),
  ///           color: _lists[index].isOdd ? oddListColor : evenListColor,
  ///           child: Row(
  ///             children: <Widget>[
  ///               Container(
  ///                 width: 64,
  ///                 height: 64,
  ///                 padding: const EdgeInsets.all(8),
  ///                 child: ReorderableDragStartListener(
  ///                   index: index,
  ///                   child: Card(
  ///                     color: colorScheme.primary,
  ///                     elevation: 2,
  ///                   ),
  ///                 ),
  ///               ),
  ///               Text('List ${_lists[index]}'),
  ///             ],
  ///           ),
  ///         ),
  ///     ],
  ///     onReorder: (oldIndex, newIndex) {
  ///       setState(() {
  ///         if (oldIndex < newIndex) {
  ///           newIndex -= 1;
  ///         }
  ///         final int list = _lists.removeAt(oldIndex);
  ///         _lists.insert(newIndex, list);
  ///       });
  ///     },
  ///   );
  /// }
  /// ```
  ///{@end-tool}
  final bool buildDefaultDragHandles;

  /// {@macro flutter.widgets.reorderable_list.padding}
  final EdgeInsets padding;

  /// A non-reorderable header list to show before the lists of the list.
  ///
  /// If null, no header will appear before the list.
  final Widget? header;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.scroll_view.primary}

  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [scrollController] is null.
  final bool? primary;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.scroll_view.shrinkWrap}
  final bool shrinkWrap;

  /// {@macro flutter.widgets.scroll_view.anchor}
  final double anchor;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  ///
  /// The default is [ScrollViewKeyboardDismissBehavior.manual]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  _ReworkedDragAndDropListsViewState createState() =>
      _ReworkedDragAndDropListsViewState();
}

// This top-level state manages an Overlay that contains the list and
// also any lists being dragged on top fo the list.
//
// The Overlay doesn't properly keep state by building new overlay entries,
// and so we cache a single OverlayEntry for use as the list layer.
// That overlay entry then builds a _ReorderableListContent which may
// insert lists being dragged into the Overlay above itself.
class _ReworkedDragAndDropListsViewState
    extends State<ReworkedDragAndDropListsView> {
  // This entry contains the scrolling list itself.
  late OverlayEntry _listOverlayEntry;

  @override
  void initState() {
    super.initState();
    _listOverlayEntry = OverlayEntry(
      opaque: true,
      builder: (BuildContext context) {
        return _ReorderableListContent(
          listBuilder: widget.listBuilder,
          listCount: widget.listCount,
          onReorder: widget.onReorder,
          proxyDecorator: widget.proxyDecorator,
          buildDefaultDragHandles: widget.buildDefaultDragHandles,
          padding: widget.padding,
          header: widget.header,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          scrollController: widget.scrollController,
          primary: widget.primary,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          anchor: widget.anchor,
          cacheExtent: widget.cacheExtent,
          dragStartBehavior: widget.dragStartBehavior,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
        );
      },
    );
  }

  @override
  void didUpdateWidget(ReworkedDragAndDropListsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // As this depends on pretty much everything, it
    // is ok to mark this as dirty unconditionally.
    _listOverlayEntry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return Overlay(
      initialEntries: <OverlayEntry>[_listOverlayEntry],
    );
  }
}

class _ReorderableListContent extends StatefulWidget {
  const _ReorderableListContent({
    required this.listBuilder,
    required this.listCount,
    required this.onReorder,
    required this.proxyDecorator,
    required this.buildDefaultDragHandles,
    required this.padding,
    required this.header,
    required this.scrollDirection,
    required this.reverse,
    required this.scrollController,
    required this.primary,
    required this.physics,
    required this.shrinkWrap,
    required this.anchor,
    required this.cacheExtent,
    required this.dragStartBehavior,
    required this.keyboardDismissBehavior,
    required this.restorationId,
    required this.clipBehavior,
  });

  final IndexedWidgetBuilder listBuilder;
  final int listCount;
  final ReorderCallback onReorder;
  final DragAndDropListsListProxyDecorator? proxyDecorator;
  final bool buildDefaultDragHandles;
  final EdgeInsets padding;
  final Widget? header;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double anchor;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  _ReorderableListContentState createState() => _ReorderableListContentState();
}

class _ReorderableListContentState extends State<_ReorderableListContent> {
  Widget _wrapWithSemantics(Widget child, int index) {
    void reorder(int startIndex, int endIndex) {
      if (startIndex != endIndex) widget.onReorder(startIndex, endIndex);
    }

    // First, determine which semantics actions apply.
    final Map<CustomSemanticsAction, VoidCallback> semanticsActions =
        <CustomSemanticsAction, VoidCallback>{};

    // Create the appropriate semantics actions.
    void moveToStart() => reorder(index, 0);
    void moveToEnd() => reorder(index, widget.listCount);
    void moveBefore() => reorder(index, index - 1);
    // To move after, we go to index+2 because we are moving it to the space
    // before index+2, which is after the space at index+1.
    void moveAfter() => reorder(index, index + 2);

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    // If the list can move to before its current position in the list.
    if (index > 0) {
      semanticsActions[
              CustomSemanticsAction(label: localizations.reorderItemToStart)] =
          moveToStart;
      String reorderItemBefore = localizations.reorderItemUp;
      if (widget.scrollDirection == Axis.horizontal) {
        reorderItemBefore = Directionality.of(context) == TextDirection.ltr
            ? localizations.reorderItemLeft
            : localizations.reorderItemRight;
      }
      semanticsActions[CustomSemanticsAction(label: reorderItemBefore)] =
          moveBefore;
    }

    // If the list can move to after its current position in the list.
    if (index < widget.listCount - 1) {
      String reorderItemAfter = localizations.reorderItemDown;
      if (widget.scrollDirection == Axis.horizontal) {
        reorderItemAfter = Directionality.of(context) == TextDirection.ltr
            ? localizations.reorderItemRight
            : localizations.reorderItemLeft;
      }
      semanticsActions[CustomSemanticsAction(label: reorderItemAfter)] =
          moveAfter;
      semanticsActions[
              CustomSemanticsAction(label: localizations.reorderItemToEnd)] =
          moveToEnd;
    }

    // We pass toWrap with a GlobalKey into the list so that when it
    // gets dragged, the accessibility framework can preserve the selected
    // state of the dragging list.
    //
    // We also apply the relevant custom accessibility actions for moving the list
    // up, down, to the start, and to the end of the list.
    return MergeSemantics(
      child: Semantics(
        customSemanticsActions: semanticsActions,
        child: child,
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    final Widget list = widget.listBuilder(context, index);

    // TODO(goderbauer): The semantics stuff should probably happen inside
    //   _ReorderableList so the widget versions can have them as well.
    final Widget listWithSemantics = _wrapWithSemantics(list, index);
    final Key listGlobalKey =
        _ReworkedDragAndDropListsViewChildGlobalKey(list.key!, this);

    if (widget.buildDefaultDragHandles) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
          return Stack(
            key: listGlobalKey,
            children: <Widget>[
              listWithSemantics,
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 0,
                bottom: 0,
                end: 8,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: DragAndDropListsDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
              ),
            ],
          );

        case TargetPlatform.iOS:
        case TargetPlatform.android:
          return DragAndDropListsDelayedDragStartListener(
            key: listGlobalKey,
            index: index,
            child: listWithSemantics,
          );
      }
    }

    return KeyedSubtree(
      key: listGlobalKey,
      child: listWithSemantics,
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          child: child,
          elevation: elevation,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If there is a header we can't just apply the padding to the list,
    // so we wrap the CustomScrollView in the padding for the top, left and right
    // and only add the padding from the bottom to the sliver list (or the equivalent
    // for other axis directions).
    final EdgeInsets padding = widget.padding;
    late EdgeInsets outerPadding;
    late EdgeInsets listPadding;
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        if (widget.reverse) {
          outerPadding = EdgeInsets.fromLTRB(
              0, padding.top, padding.right, padding.bottom);
          listPadding = EdgeInsets.fromLTRB(padding.left, 0, 0, 0);
        } else {
          outerPadding =
              EdgeInsets.fromLTRB(padding.left, padding.top, 0, padding.bottom);
          listPadding = EdgeInsets.fromLTRB(0, 0, padding.right, 0);
        }
        break;
      case Axis.vertical:
        if (widget.reverse) {
          outerPadding = EdgeInsets.fromLTRB(
              padding.left, 0, padding.right, padding.bottom);
          listPadding = EdgeInsets.fromLTRB(0, padding.top, 0, 0);
        } else {
          outerPadding =
              EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, 0);
          listPadding = EdgeInsets.fromLTRB(0, 0, 0, padding.bottom);
        }
        break;
    }

    return Padding(
      padding: outerPadding,
      child: CustomScrollView(
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.scrollController,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        anchor: widget.anchor,
        cacheExtent: widget.cacheExtent,
        dragStartBehavior: widget.dragStartBehavior,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        slivers: <Widget>[
          if (widget.header != null) SliverToBoxAdapter(child: widget.header!),
          SliverPadding(
            padding: listPadding,
            sliver: SliverDragAndDropListsReworked(
              listBuilder: _listBuilder,
              listCount: widget.listCount,
              onReorder: widget.onReorder,
              proxyDecorator: widget.proxyDecorator ?? _proxyDecorator,
            ),
          ),
        ],
      ),
    );
  }
}

// A global key that takes its identity from the object and uses a value of a
// particular type to identify itself.
//
// The difference with GlobalObjectKey is that it uses [==] instead of [identical]
// of the objects used to generate widgets.
@optionalTypeArgs
class _ReworkedDragAndDropListsViewChildGlobalKey extends GlobalObjectKey {
  const _ReworkedDragAndDropListsViewChildGlobalKey(this.subKey, this.state)
      : super(subKey);

  final Key subKey;
  final State state;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _ReworkedDragAndDropListsViewChildGlobalKey &&
        other.subKey == subKey &&
        other.state == state;
  }

  @override
  int get hashCode => hashValues(subKey, state);
}
