// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Examples can assume:
// class MyDataObject {}

/// A callback used by [DragAndDropListsReworked] to report that a list list has moved
/// to a new position in the list.
///
/// Implementations should remove the corresponding list list at [oldIndex]
/// and reinsert it at [newIndex].
///
/// If [oldIndex] is before [newIndex], removing the list at [oldIndex] from the
/// list will reduce the list's length by one. Implementations will need to
/// account for this when inserting before [newIndex].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=3fB1mxOsqJE}
///
/// {@tool snippet}
///
/// ```dart
/// final List<MyDataObject> backingList = <MyDataObject>[/* ... */];
///
/// void handleReorder(int oldIndex, int newIndex) {
///   if (oldIndex < newIndex) {
///     // removing the list at oldIndex will shorten the list by 1.
///     newIndex -= 1;
///   }
///   final MyDataObject element = backingList.removeAt(oldIndex);
///   backingList.insert(newIndex, element);
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [DragAndDropListsReworked], a widget list that allows the user to reorder
///    its lists.
///  * [SliverDragAndDropListsReworked], a sliver list that allows the user to reorder
///    its lists.
///  * [DragAndDropListsReworkedView], a material design list that allows the user to
///    reorder its lists.
typedef ListReorderCallback = void Function(int oldIndex, int newIndex);

/// Signature for the builder callback used to decorate the dragging list in
/// [DragAndDropListsReworked] and [SliverDragAndDropListsReworked].
///
/// The [child] will be the list that is being dragged, and [index] is the
/// position of the list in the list.
///
/// The [animation] will be driven forward from 0.0 to 1.0 while the list is
/// being picked up during a drag operation, and reversed from 1.0 to 0.0 when
/// the list is dropped. This can be used to animate properties of the proxy
/// like an elevation or border.
///
/// The returned value will typically be the [child] wrapped in other widgets.
typedef DragAndDropListsListProxyDecorator = Widget Function(
    Widget child, int index, Animation<double> animation);

/// A scrolling container that allows the user to interactively reorder the
/// list lists.
///
/// This widget is similar to one created by [ListView.builder], and uses
/// an [IndexedWidgetBuilder] to create each list.
///
/// It is up to the application to wrap each child (or an internal part of the
/// child such as a drag handle) with a drag listener that will recognize
/// the start of an list drag and then start the reorder by calling
/// [DragAndDropListsReworkedState.startListDragReorder]. This is most easily achieved
/// by wrapping each child in a [DragAndDropListsDragStartListener] or a
/// [DragAndDropListsDelayedDragStartListener]. These will take care of recognizing
/// the start of a drag gesture and call the list state's
/// [DragAndDropListsReworkedState.startListDragReorder] method.
///
/// This widget's [DragAndDropListsReworkedState] can be used to manually start an list
/// reorder, or cancel a current drag. To refer to the
/// [DragAndDropListsReworkedState] either provide a [GlobalKey] or use the static
/// [DragAndDropListsReworked.of] method from an list's build method.
///
/// See also:
///
///  * [SliverDragAndDropListsReworked], a sliver list that allows the user to reorder
///    its lists.
///  * [DragAndDropListsReworkedView], a material design list that allows the user to
///    reorder its lists.
class DragAndDropListsReworked extends StatefulWidget {
  /// Creates a scrolling container that allows the user to interactively
  /// reorder the list lists.
  ///
  /// The [listCount] must be greater than or equal to zero.
  const DragAndDropListsReworked({
    Key? key,
    required this.listBuilder,
    required this.listCount,
    required this.onReorder,
    this.proxyDecorator,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : assert(listCount >= 0),
        super(key: key);

  /// {@template flutter.widgets.reorderable_list.listBuilder}
  /// Called, as needed, to build list list widgets.
  ///
  /// List lists are only built when they're scrolled into view.
  ///
  /// The [IndexedWidgetBuilder] index parameter indicates the list's
  /// position in the list. The value of the index parameter will be between
  /// zero and one less than [listCount]. All lists in the list must have a
  /// unique [Key], and should have some kind of listener to start the drag
  /// (usually a [DragAndDropListsDragStartListener] or
  /// [DragAndDropListsDelayedDragStartListener]).
  /// {@endtemplate}
  final IndexedWidgetBuilder listBuilder;

  /// {@template flutter.widgets.reorderable_list.listCount}
  /// The number of lists in the list.
  ///
  /// It must be a non-negative integer. When zero, nothing is displayed and
  /// the widget occupies no space.
  /// {@endtemplate}
  final int listCount;

  /// {@template flutter.widgets.reorderable_list.onReorder}
  /// A callback used by the list to report that a list list has been dragged
  /// to a new location in the list and the application should update the order
  /// of the lists.
  /// {@endtemplate}
  final ListReorderCallback onReorder;

  /// {@template flutter.widgets.reorderable_list.proxyDecorator}
  /// A callback that allows the app to add an animated decoration around
  /// an list when it is being dragged.
  /// {@endtemplate}
  final DragAndDropListsListProxyDecorator? proxyDecorator;

  /// {@template flutter.widgets.reorderable_list.padding}
  /// The amount of space by which to inset the list contents.
  ///
  /// It defaults to `EdgeInsets.all(0)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.scroll_view.primary}
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

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [DragAndDropListsReworked] list widgets that
  /// insert or remove lists in response to user input.
  ///
  /// If no [DragAndDropListsReworked] surrounds the given context, then this function
  /// will assert in debug mode and throw an exception in release mode.
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [DragAndDropListsReworked] ancestor is found.
  static DragAndDropListsReworkedState of(BuildContext context) {
    final DragAndDropListsReworkedState? result =
        context.findAncestorStateOfType<DragAndDropListsReworkedState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'DragAndDropListsReworked.of() called with a context that does not contain a DragAndDropListsReworked.'),
          ErrorDescription(
              'No DragAndDropListsReworked ancestor could be found starting from the context that was passed to DragAndDropListsReworked.of().'),
          ErrorHint(
              'This can happen when the context provided is from the same StatefulWidget that '
              'built the DragAndDropListsReworked. Please see the DragAndDropListsReworked documentation for examples '
              'of how to refer to an DragAndDropListsReworkedState object:'
              '  https://api.flutter.dev/flutter/widgets/DragAndDropListsReworkedState-class.html'),
          context.describeElement('The context used was')
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [DragAndDropListsReworked] list widgets that insert
  /// or remove lists in response to user input.
  ///
  /// If no [DragAndDropListsReworked] surrounds the context given, then this function will
  /// return null.
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [DragAndDropListsReworked] ancestor
  ///    is found.
  static DragAndDropListsReworkedState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<DragAndDropListsReworkedState>();
  }

  @override
  DragAndDropListsReworkedState createState() =>
      DragAndDropListsReworkedState();
}

/// The state for a list that allows the user to interactively reorder
/// the list lists.
///
/// An app that needs to start a new list drag or cancel an existing one
/// can refer to the [DragAndDropListsReworked]'s state with a global key:
///
/// ```dart
/// GlobalKey<DragAndDropListsReworkedState> listKey = GlobalKey<DragAndDropListsReworkedState>();
/// ...
/// DragAndDropListsReworked(key: listKey, ...);
/// ...
/// listKey.currentState.cancelReorder();
/// ```
class DragAndDropListsReworkedState extends State<DragAndDropListsReworked> {
  final GlobalKey<SliverDragAndDropListsReworkedState>
      _sliverDragAndDropListsReworkedKey = GlobalKey();

  /// Initiate the dragging of the list at [index] that was started with
  /// the pointer down [event].
  ///
  /// The given [recognizer] will be used to recognize and start the drag
  /// list tracking and lead to either an list reorder, or a cancelled drag.
  /// The list will take ownership of the returned recognizer and will dispose
  /// it when it is no longer needed.
  ///
  /// Most applications will not use this directly, but will wrap the list
  /// (or part of the list, like a drag handle) in either a
  /// [DragAndDropListsDragStartListener] or [DragAndDropListsDelayedDragStartListener]
  /// which call this for the application.
  void startListDragReorder({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer<MultiDragPointerState> recognizer,
  }) {
    _sliverDragAndDropListsReworkedKey.currentState!.startListDragReorder(
        index: index, event: event, recognizer: recognizer);
  }

  /// Cancel any list drag in progress.
  ///
  /// This should be called before any major changes to the list list
  /// occur so that any list drags will not get confused by
  /// changes to the underlying list.
  ///
  /// If no drag is active, this will do nothing.
  void cancelReorder() {
    _sliverDragAndDropListsReworkedKey.currentState!.cancelReorder();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
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
        SliverPadding(
          padding: widget.padding,
          sliver: SliverDragAndDropListsReworked(
            key: _sliverDragAndDropListsReworkedKey,
            listBuilder: widget.listBuilder,
            listCount: widget.listCount,
            onReorder: widget.onReorder,
            proxyDecorator: widget.proxyDecorator,
          ),
        ),
      ],
    );
  }
}

/// A sliver list that allows the user to interactively reorder the list lists.
///
/// It is up to the application to wrap each child (or an internal part of the
/// child) with a drag listener that will recognize the start of an list drag
/// and then start the reorder by calling
/// [SliverDragAndDropListsReworkedState.startListDragReorder]. This is most easily
/// achieved by wrapping each child in a [DragAndDropListsDragStartListener] or
/// a [DragAndDropListsDelayedDragStartListener]. These will take care of
/// recognizing the start of a drag gesture and call the list state's start
/// list drag method.
///
/// This widget's [SliverDragAndDropListsReworkedState] can be used to manually start an list
/// reorder, or cancel a current drag that's already underway. To refer to the
/// [SliverDragAndDropListsReworkedState] either provide a [GlobalKey] or use the static
/// [SliverDragAndDropListsReworked.of] method from an list's build method.
///
/// See also:
///
///  * [DragAndDropListsReworked], a regular widget list that allows the user to reorder
///    its lists.
///  * [DragAndDropListsReworkedView], a material design list that allows the user to
///    reorder its lists.
class SliverDragAndDropListsReworked extends StatefulWidget {
  /// Creates a sliver list that allows the user to interactively reorder its
  /// lists.
  ///
  /// The [listCount] must be greater than or equal to zero.
  const SliverDragAndDropListsReworked({
    Key? key,
    required this.listBuilder,
    required this.listCount,
    required this.onReorder,
    this.proxyDecorator,
  })  : assert(listCount >= 0),
        super(key: key);

  /// {@macro flutter.widgets.reorderable_list.listBuilder}
  final IndexedWidgetBuilder listBuilder;

  /// {@macro flutter.widgets.reorderable_list.listCount}
  final int listCount;

  /// {@macro flutter.widgets.reorderable_list.onReorder}
  final ListReorderCallback onReorder;

  /// {@macro flutter.widgets.reorderable_list.proxyDecorator}
  final DragAndDropListsListProxyDecorator? proxyDecorator;

  @override
  SliverDragAndDropListsReworkedState createState() =>
      SliverDragAndDropListsReworkedState();

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverDragAndDropListsReworked] list widgets to
  /// start or cancel an list drag operation.
  ///
  /// If no [SliverDragAndDropListsReworked] surrounds the context given, this function
  /// will assert in debug mode and throw an exception in release mode.
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [SliverDragAndDropListsReworked] ancestor is found.
  static SliverDragAndDropListsReworkedState of(BuildContext context) {
    final SliverDragAndDropListsReworkedState? result =
        context.findAncestorStateOfType<SliverDragAndDropListsReworkedState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'SliverDragAndDropListsReworked.of() called with a context that does not contain a SliverDragAndDropListsReworked.'),
          ErrorDescription(
              'No SliverDragAndDropListsReworked ancestor could be found starting from the context that was passed to SliverDragAndDropListsReworked.of().'),
          ErrorHint(
              'This can happen when the context provided is from the same StatefulWidget that '
              'built the SliverDragAndDropListsReworked. Please see the SliverDragAndDropListsReworked documentation for examples '
              'of how to refer to an SliverDragAndDropListsReworked object:'
              '  https://api.flutter.dev/flutter/widgets/SliverDragAndDropListsReworkedState-class.html'),
          context.describeElement('The context used was')
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverDragAndDropListsReworked] list widgets that
  /// insert or remove lists in response to user input.
  ///
  /// If no [SliverDragAndDropListsReworked] surrounds the context given, this function
  /// will return null.
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [SliverDragAndDropListsReworked]
  ///    ancestor is found.
  static SliverDragAndDropListsReworkedState? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<SliverDragAndDropListsReworkedState>();
  }
}

/// The state for a sliver list that allows the user to interactively reorder
/// the list lists.
///
/// An app that needs to start a new list drag or cancel an existing one
/// can refer to the [SliverDragAndDropListsReworked]'s state with a global key:
///
/// ```dart
/// GlobalKey<SliverDragAndDropListsReworkedState> listKey = GlobalKey<SliverDragAndDropListsReworkedState>();
/// ...
/// SliverDragAndDropListsReworked(key: listKey, ...);
/// ...
/// listKey.currentState.cancelReorder();
/// ```
///
/// [DragAndDropListsDragStartListener] and [DragAndDropListsDelayedDragStartListener]
/// refer to their [SliverDragAndDropListsReworked] with the static
/// [SliverDragAndDropListsReworked.of] method.
class SliverDragAndDropListsReworkedState
    extends State<SliverDragAndDropListsReworked>
    with TickerProviderStateMixin {
  // Map of index -> child state used manage where the dragging list will need
  // to be inserted.
  final Map<int, _ReorderableListState> _lists = <int, _ReorderableListState>{};

  bool _reorderingDrag = false;
  bool _autoScrolling = false;
  OverlayEntry? _overlayEntry;
  _ReorderableListState? _dragList;
  _DragInfo? _dragInfo;
  int? _insertIndex;
  Offset? _finalDropPosition;
  MultiDragGestureRecognizer<MultiDragPointerState>? _recognizer;

  late ScrollableState _scrollable;
  Axis get _scrollDirection => axisDirectionToAxis(_scrollable.axisDirection);
  bool get _reverse =>
      _scrollable.axisDirection == AxisDirection.up ||
      _scrollable.axisDirection == AxisDirection.left;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollable = Scrollable.of(context)!;
  }

  @override
  void didUpdateWidget(covariant SliverDragAndDropListsReworked oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listCount != oldWidget.listCount) {
      cancelReorder();
    }
  }

  @override
  void dispose() {
    _dragInfo?.dispose();
    super.dispose();
  }

  /// Initiate the dragging of the list at [index] that was started with
  /// the pointer down [event].
  ///
  /// The given [recognizer] will be used to recognize and start the drag
  /// list tracking and lead to either an list reorder, or a cancelled drag.
  ///
  /// Most applications will not use this directly, but will wrap the list
  /// (or part of the list, like a drag handle) in either a
  /// [DragAndDropListsDragStartListener] or [DragAndDropListsDelayedDragStartListener]
  /// which call this method when they detect the gesture that triggers a drag
  /// start.
  void startListDragReorder({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer<MultiDragPointerState> recognizer,
  }) {
    assert(0 <= index && index < widget.listCount);
    setState(() {
      if (_reorderingDrag) {
        cancelReorder();
      }
      if (_lists.containsKey(index)) {
        _dragList = _lists[index]!;
        _recognizer = recognizer
          ..onStart = _dragStart
          ..addPointer(event);
      } else {
        // TODO(darrenaustin): Can we handle this better, maybe scroll to the list?
        throw Exception('Attempting to start a drag on a non-visible list');
      }
    });
  }

  /// Cancel any list drag in progress.
  ///
  /// This should be called before any major changes to the list list
  /// occur so that any list drags will not get confused by
  /// changes to the underlying list.
  ///
  /// If a drag operation is in progress, this will immediately reset
  /// the list to back to its pre-drag state.
  ///
  /// If no drag is active, this will do nothing.
  void cancelReorder() {
    _dragReset();
  }

  void _registerList(_ReorderableListState list) {
    _lists[list.index] = list;
  }

  void _unregisterList(int index, _ReorderableListState list) {
    final _ReorderableListState? currentList = _lists[index];
    if (currentList == list) {
      _lists.remove(index);
    }
  }

  Drag? _dragStart(Offset position) {
    assert(_reorderingDrag == false);
    final _ReorderableListState list = _dragList!;

    _insertIndex = list.index;
    _reorderingDrag = true;
    _dragInfo = _DragInfo(
      list: list,
      initialPosition: position,
      scrollDirection: _scrollDirection,
      onUpdate: _dragUpdate,
      onCancel: _dragCancel,
      onEnd: _dragEnd,
      onDropCompleted: _dropCompleted,
      proxyDecorator: widget.proxyDecorator,
      tickerProvider: this,
    );

    final OverlayState overlay = Overlay.of(context)!;
    assert(_overlayEntry == null);
    _overlayEntry = OverlayEntry(builder: _dragInfo!.createProxy);
    overlay.insert(_overlayEntry!);

    _dragInfo!.startDrag();

    list.dragging = true;
    for (final _ReorderableListState childList in _lists.values) {
      if (childList == list || !childList.mounted) continue;
      childList.updateForGap(
          _insertIndex!, _dragInfo!.listExtent, false, _reverse);
    }
    return _dragInfo;
  }

  void _dragUpdate(_DragInfo list, Offset position, Offset delta) {
    setState(() {
      _overlayEntry?.markNeedsBuild();
      _dragUpdateLists();
      _autoScrollIfNecessary();
    });
  }

  void _dragCancel(_DragInfo list) {
    _dragReset();
  }

  void _dragEnd(_DragInfo list) {
    setState(() {
      if (_insertIndex! < widget.listCount - 1) {
        // Find the location of the list we want to insert before
        _finalDropPosition = _listOffsetAt(_insertIndex!);
      } else {
        // Inserting into the last spot on the list. If it's the only spot, put
        // it back where it was. Otherwise, grab the second to last and move
        // down by the gap.
        final int listIndex =
            _lists.length > 1 ? _insertIndex! - 1 : _insertIndex!;
        if (_reverse) {
          _finalDropPosition = _listOffsetAt(listIndex) -
              _extentOffset(list.listExtent, _scrollDirection);
        } else {
          _finalDropPosition = _listOffsetAt(listIndex) +
              _extentOffset(list.listExtent, _scrollDirection);
        }
      }
    });
  }

  void _dropCompleted() {
    final int fromIndex = _dragList!.index;
    final int toIndex = _insertIndex!;
    if (fromIndex != toIndex) {
      widget.onReorder.call(fromIndex, toIndex);
    }
    _dragReset();
  }

  void _dragReset() {
    setState(() {
      if (_reorderingDrag) {
        _reorderingDrag = false;
        _dragList!.dragging = false;
        _dragList = null;
        _dragInfo?.dispose();
        _dragInfo = null;
        _resetListGap();
        _recognizer?.dispose();
        _recognizer = null;
        _overlayEntry?.remove();
        _overlayEntry = null;
        _finalDropPosition = null;
      }
    });
  }

  void _resetListGap() {
    for (final _ReorderableListState list in _lists.values) {
      list.resetGap();
    }
  }

  void _dragUpdateLists() {
    assert(_reorderingDrag);
    assert(_dragList != null);
    assert(_dragInfo != null);
    final _ReorderableListState gapList = _dragList!;
    final double gapExtent = _dragInfo!.listExtent;
    final double proxyListStart = _offsetExtent(
        _dragInfo!.dragPosition - _dragInfo!.dragOffset, _scrollDirection);
    final double proxyListEnd = proxyListStart + gapExtent;

    // Find the new index for inserting the list being dragged.
    int newIndex = _insertIndex!;
    for (final _ReorderableListState list in _lists.values) {
      if (list == gapList || !list.mounted) continue;

      final Rect geometry = list.targetGeometry();
      final double listStart =
          _scrollDirection == Axis.vertical ? geometry.top : geometry.left;
      final double listExtent =
          _scrollDirection == Axis.vertical ? geometry.height : geometry.width;
      final double listEnd = listStart + listExtent;
      final double listMiddle = listStart + listExtent / 2;

      if (_reverse) {
        if (listEnd >= proxyListEnd && proxyListEnd >= listMiddle) {
          // The start of the proxy is in the beginning half of the list, so
          // we should swap the list with the gap and we are done looking for
          // the new index.
          newIndex = list.index;
          break;
        } else if (listMiddle >= proxyListStart &&
            proxyListStart >= listStart) {
          // The end of the proxy is in the ending half of the list, so
          // we should swap the list with the gap and we are done looking for
          // the new index.
          newIndex = list.index + 1;
          break;
        } else if (listStart > proxyListEnd && newIndex < (list.index + 1)) {
          newIndex = list.index + 1;
        } else if (proxyListStart > listEnd && newIndex > list.index) {
          newIndex = list.index;
        }
      } else {
        if (listStart <= proxyListStart && proxyListStart <= listMiddle) {
          // The start of the proxy is in the beginning half of the list, so
          // we should swap the list with the gap and we are done looking for
          // the new index.
          newIndex = list.index;
          break;
        } else if (listMiddle <= proxyListEnd && proxyListEnd <= listEnd) {
          // The end of the proxy is in the ending half of the list, so
          // we should swap the list with the gap and we are done looking for
          // the new index.
          newIndex = list.index + 1;
          break;
        } else if (listEnd < proxyListStart && newIndex < (list.index + 1)) {
          newIndex = list.index + 1;
        } else if (proxyListEnd < listStart && newIndex > list.index) {
          newIndex = list.index;
        }
      }
    }

    if (newIndex != _insertIndex) {
      _insertIndex = newIndex;
      for (final _ReorderableListState list in _lists.values) {
        if (list == gapList || !list.mounted) continue;
        list.updateForGap(newIndex, gapExtent, true, _reverse);
      }
    }
  }

  Future<void> _autoScrollIfNecessary() async {
    if (!_autoScrolling && _dragInfo != null && _dragInfo!.scrollable != null) {
      final ScrollPosition position = _dragInfo!.scrollable!.position;
      double? newOffset;
      const Duration duration = Duration(milliseconds: 14);
      const double step = 1.0;
      const double overDragMax = 20.0;
      const double overDragCoef = 10;

      final RenderBox scrollRenderBox =
          _dragInfo!.scrollable!.context.findRenderObject()! as RenderBox;
      final Offset scrollOrigin = scrollRenderBox.localToGlobal(Offset.zero);
      final double scrollStart = _offsetExtent(scrollOrigin, _scrollDirection);
      final double scrollEnd =
          scrollStart + _sizeExtent(scrollRenderBox.size, _scrollDirection);

      final double proxyStart = _offsetExtent(
          _dragInfo!.dragPosition - _dragInfo!.dragOffset, _scrollDirection);
      final double proxyEnd = proxyStart + _dragInfo!.listExtent;

      if (_reverse) {
        if (proxyEnd > scrollEnd &&
            position.pixels > position.minScrollExtent) {
          final double overDrag = max(proxyEnd - scrollEnd, overDragMax);
          newOffset = max(position.minScrollExtent,
              position.pixels - step * overDrag / overDragCoef);
        } else if (proxyStart < scrollStart &&
            position.pixels < position.maxScrollExtent) {
          final double overDrag = max(scrollStart - proxyStart, overDragMax);
          newOffset = min(position.maxScrollExtent,
              position.pixels + step * overDrag / overDragCoef);
        }
      } else {
        if (proxyStart < scrollStart &&
            position.pixels > position.minScrollExtent) {
          final double overDrag = max(scrollStart - proxyStart, overDragMax);
          newOffset = max(position.minScrollExtent,
              position.pixels - step * overDrag / overDragCoef);
        } else if (proxyEnd > scrollEnd &&
            position.pixels < position.maxScrollExtent) {
          final double overDrag = max(proxyEnd - scrollEnd, overDragMax);
          newOffset = min(position.maxScrollExtent,
              position.pixels + step * overDrag / overDragCoef);
        }
      }

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _autoScrolling = true;
        await position.animateTo(newOffset,
            duration: duration, curve: Curves.linear);
        _autoScrolling = false;
        if (_dragList != null) {
          _dragUpdateLists();
          _autoScrollIfNecessary();
        }
      }
    }
  }

  Offset _listOffsetAt(int index) {
    final RenderBox listRenderBox =
        _lists[index]!.context.findRenderObject()! as RenderBox;
    return listRenderBox.localToGlobal(Offset.zero);
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (_dragInfo != null && index >= widget.listCount) {
      switch (_scrollDirection) {
        case Axis.horizontal:
          return SizedBox(width: _dragInfo!.listExtent);
        case Axis.vertical:
          return SizedBox(height: _dragInfo!.listExtent);
      }
    }
    final Widget child = widget.listBuilder(context, index);
    assert(child.key != null, 'All list lists must have a key');
    final OverlayState overlay = Overlay.of(context)!;
    return _ReorderableList(
      key: _DragAndDropListsListGlobalKey(child.key!, index, this),
      index: index,
      child: child,
      capturedThemes:
          InheritedTheme.capture(from: context, to: overlay.context),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));
    return SliverList(
      // When dragging, the dragged list is still in the list but has been replaced
      // by a zero height SizedBox, so that the gap can move around. To make the
      // list extent stable we add a dummy entry to the end.
      delegate: SliverChildBuilderDelegate(_listBuilder,
          childCount: widget.listCount + (_reorderingDrag ? 1 : 0)),
    );
  }
}

class _ReorderableList extends StatefulWidget {
  const _ReorderableList({
    required Key key,
    required this.index,
    required this.child,
    required this.capturedThemes,
  }) : super(key: key);

  final int index;
  final Widget child;
  final CapturedThemes capturedThemes;

  @override
  _ReorderableListState createState() => _ReorderableListState();
}

class _ReorderableListState extends State<_ReorderableList> {
  late SliverDragAndDropListsReworkedState _listState;

  Offset _startOffset = Offset.zero;
  Offset _targetOffset = Offset.zero;
  AnimationController? _offsetAnimation;

  Key get key => widget.key!;
  int get index => widget.index;

  bool get dragging => _dragging;
  set dragging(bool dragging) {
    if (mounted) {
      setState(() {
        _dragging = dragging;
      });
    }
  }

  bool _dragging = false;

  @override
  void initState() {
    _listState = SliverDragAndDropListsReworked.of(context);
    _listState._registerList(this);
    super.initState();
  }

  @override
  void dispose() {
    _offsetAnimation?.dispose();
    _listState._unregisterList(index, this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ReorderableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _listState._unregisterList(oldWidget.index, this);
      _listState._registerList(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dragging) {
      return const SizedBox();
    }
    _listState._registerList(this);
    return Transform(
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0.0),
      child: widget.child,
    );
  }

  @override
  void deactivate() {
    _listState._unregisterList(index, this);
    super.deactivate();
  }

  Offset get offset {
    if (_offsetAnimation != null) {
      final double animValue =
          Curves.easeInOut.transform(_offsetAnimation!.value);
      return Offset.lerp(_startOffset, _targetOffset, animValue)!;
    }
    return _targetOffset;
  }

  void updateForGap(
      int gapIndex, double gapExtent, bool animate, bool reverse) {
    final Offset newTargetOffset = (gapIndex <= index)
        ? _extentOffset(
            reverse ? -gapExtent : gapExtent, _listState._scrollDirection)
        : Offset.zero;
    if (newTargetOffset != _targetOffset) {
      _targetOffset = newTargetOffset;
      if (animate) {
        if (_offsetAnimation == null) {
          _offsetAnimation = AnimationController(
            vsync: _listState,
            duration: const Duration(milliseconds: 250),
          )
            ..addListener(rebuild)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                _startOffset = _targetOffset;
                _offsetAnimation!.dispose();
                _offsetAnimation = null;
              }
            })
            ..forward();
        } else {
          _startOffset = offset;
          _offsetAnimation!.forward(from: 0.0);
        }
      } else {
        if (_offsetAnimation != null) {
          _offsetAnimation!.dispose();
          _offsetAnimation = null;
        }
        _startOffset = _targetOffset;
      }
      rebuild();
    }
  }

  void resetGap() {
    if (_offsetAnimation != null) {
      _offsetAnimation!.dispose();
      _offsetAnimation = null;
    }
    _startOffset = Offset.zero;
    _targetOffset = Offset.zero;
    rebuild();
  }

  Rect targetGeometry() {
    final RenderBox listRenderBox = context.findRenderObject()! as RenderBox;
    final Offset listPosition =
        listRenderBox.localToGlobal(Offset.zero) + _targetOffset;
    return listPosition & listRenderBox.size;
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}

/// A wrapper widget that will recognize the start of a drag on the wrapped
/// widget by a [PointerDownEvent], and immediately initiate dragging the
/// wrapped list to a new location in a reorderable list.
///
/// See also:
///
///  * [DragAndDropListsDelayedDragStartListener], a similar wrapper that will
///    only recognize the start after a long press event.
///  * [DragAndDropListsReworked], a widget list that allows the user to reorder
///    its lists.
///  * [SliverDragAndDropListsReworked], a sliver list that allows the user to reorder
///    its lists.
///  * [DragAndDropListsReworkedView], a material design list that allows the user to
///    reorder its lists.
class DragAndDropListsDragStartListener extends StatelessWidget {
  /// Creates a listener for a drag immediately following a pointer down
  /// event over the given child widget.
  ///
  /// This is most commonly used to wrap part of a list list like a drag
  /// handle.
  const DragAndDropListsDragStartListener({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);

  /// The widget for which the application would like to respond to a tap and
  /// drag gesture by starting a reordering drag on a reorderable list.
  final Widget child;

  /// The index of the associated list that will be dragged in the list.
  final int index;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => _startDragging(context, event),
      child: child,
    );
  }

  /// Provides the gesture recognizer used to indicate the start of a reordering
  /// drag operation.
  ///
  /// By default this returns an [ImmediateMultiDragGestureRecognizer] but
  /// subclasses can use this to customize the drag start gesture.
  @protected
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer() {
    return ImmediateMultiDragGestureRecognizer(debugOwner: this);
  }

  void _startDragging(BuildContext context, PointerDownEvent event) {
    final SliverDragAndDropListsReworkedState? list =
        SliverDragAndDropListsReworked.maybeOf(context);
    list?.startListDragReorder(
        index: index, event: event, recognizer: createRecognizer());
  }
}

/// A wrapper widget that will recognize the start of a drag operation by
/// looking for a long press event. Once it is recognized, it will start
/// a drag operation on the wrapped list in the reorderable list.
///
/// See also:
///
///  * [DragAndDropListsDragStartListener], a similar wrapper that will
///    recognize the start of the drag immediately after a pointer down event.
///  * [DragAndDropListsReworked], a widget list that allows the user to reorder
///    its lists.
///  * [SliverDragAndDropListsReworked], a sliver list that allows the user to reorder
///    its lists.
///  * [DragAndDropListsReworkedView], a material design list that allows the user to
///    reorder its lists.
class DragAndDropListsDelayedDragStartListener
    extends DragAndDropListsDragStartListener {
  /// Creates a listener for an drag following a long press event over the
  /// given child widget.
  ///
  /// This is most commonly used to wrap an entire list list in a reorderable
  /// list.
  const DragAndDropListsDelayedDragStartListener({
    Key? key,
    required Widget child,
    required int index,
  }) : super(key: key, child: child, index: index);

  @override
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer() {
    return DelayedMultiDragGestureRecognizer(debugOwner: this);
  }
}

typedef _DragListUpdate = void Function(
    _DragInfo list, Offset position, Offset delta);
typedef _DragListCallback = void Function(_DragInfo list);

class _DragInfo extends Drag {
  _DragInfo({
    required this.list,
    Offset initialPosition = Offset.zero,
    this.scrollDirection = Axis.vertical,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    this.onDropCompleted,
    this.proxyDecorator,
    required this.tickerProvider,
  }) {
    final RenderBox listRenderBox =
        list.context.findRenderObject()! as RenderBox;
    dragPosition = initialPosition;
    dragOffset = listRenderBox.globalToLocal(initialPosition);
    listSize = list.context.size!;
    listExtent = _sizeExtent(listSize, scrollDirection);
    scrollable = Scrollable.of(list.context);
  }

  final _ReorderableListState list;
  final Axis scrollDirection;
  final _DragListUpdate? onUpdate;
  final _DragListCallback? onEnd;
  final _DragListCallback? onCancel;
  final VoidCallback? onDropCompleted;
  final DragAndDropListsListProxyDecorator? proxyDecorator;
  final TickerProvider tickerProvider;

  late Offset dragPosition;
  late Offset dragOffset;
  late Size listSize;
  late double listExtent;
  ScrollableState? scrollable;
  AnimationController? _proxyAnimation;

  void dispose() {
    _proxyAnimation?.dispose();
  }

  void startDrag() {
    _proxyAnimation = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 250),
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _dropCompleted();
        }
      })
      ..forward();
  }

  @override
  void update(DragUpdateDetails details) {
    final Offset delta = _restrictAxis(details.delta, scrollDirection);
    dragPosition += delta;
    onUpdate?.call(this, dragPosition, details.delta);
  }

  @override
  void end(DragEndDetails details) {
    _proxyAnimation!.reverse();
    onEnd?.call(this);
  }

  @override
  void cancel() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onCancel?.call(this);
  }

  void _dropCompleted() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onDropCompleted?.call();
  }

  Widget createProxy(BuildContext context) {
    return list.widget.capturedThemes.wrap(_DragListProxy(
      list: list,
      size: listSize,
      animation: _proxyAnimation!,
      position: dragPosition - dragOffset - _overlayOrigin(context),
      proxyDecorator: proxyDecorator,
    ));
  }
}

Offset _overlayOrigin(BuildContext context) {
  final OverlayState overlay = Overlay.of(context)!;
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}

class _DragListProxy extends StatelessWidget {
  const _DragListProxy({
    Key? key,
    required this.list,
    required this.position,
    required this.size,
    required this.animation,
    required this.proxyDecorator,
  }) : super(key: key);

  final _ReorderableListState list;
  final Offset position;
  final Size size;
  final AnimationController animation;
  final DragAndDropListsListProxyDecorator? proxyDecorator;

  @override
  Widget build(BuildContext context) {
    final Widget child = list.widget.child;
    final Widget proxyChild =
        proxyDecorator?.call(child, list.index, animation.view) ?? child;
    final Offset overlayOrigin = _overlayOrigin(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        Offset effectivePosition = position;
        final Offset? dropPosition = list._listState._finalDropPosition;
        if (dropPosition != null) {
          effectivePosition = Offset.lerp(dropPosition - overlayOrigin,
              effectivePosition, Curves.easeOut.transform(animation.value))!;
        }
        return Positioned(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
          left: effectivePosition.dx,
          top: effectivePosition.dy,
        );
      },
      child: proxyChild,
    );
  }
}

double _sizeExtent(Size size, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return size.width;
    case Axis.vertical:
      return size.height;
  }
}

double _offsetExtent(Offset offset, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return offset.dx;
    case Axis.vertical:
      return offset.dy;
  }
}

Offset _extentOffset(double extent, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return Offset(extent, 0.0);
    case Axis.vertical:
      return Offset(0.0, extent);
  }
}

Offset _restrictAxis(Offset offset, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return Offset(offset.dx, 0.0);
    case Axis.vertical:
      return Offset(0.0, offset.dy);
  }
}

// A global key that takes its identity from the object and uses a value of a
// particular type to identify itself.
//
// The difference with GlobalObjectKey is that it uses [==] instead of [identical]
// of the objects used to generate widgets.
@optionalTypeArgs
class _DragAndDropListsListGlobalKey extends GlobalObjectKey {
  const _DragAndDropListsListGlobalKey(this.subKey, this.index, this.state)
      : super(subKey);

  final Key subKey;
  final int index;
  final SliverDragAndDropListsReworkedState state;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _DragAndDropListsListGlobalKey &&
        other.subKey == subKey &&
        other.index == index &&
        other.state == state;
  }

  @override
  int get hashCode => hashValues(subKey, index, state);
}
