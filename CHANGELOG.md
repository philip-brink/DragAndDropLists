# Changelog

[0.4.1] - 12 June 2024

* Add key to DragAndDropItem and DragAndDropList (thanks [@saileshbro](https://github.com/saileshbro))

[0.4.0] - 11 June 2024

* Update to be compatible with Flutter 3.22.0 (thanks [@dmitry-comet](https://github.com/dmitry-comet))

[0.3.3] - 4 August 2022

* Update to flutter 3 (thanks [@mauriceraguseinit](https://github.com/mauriceraguseinit))

[0.3.2+2] - 21 October 2021

* Replace flutter deprecated elements

[0.3.2+1] - 21 October 2021

* Fix last list target for horizontal lists (thanks [@nvloc120](https://github.com/nvloc120)).
* Add ability to remove top padding when there is a widget before the DragAndDropLists (See [flutter/flutter#14842](https://github.com/flutter/flutter/issues/14842), thanks [@aliasgarlabs](https://github.com/aliasgarlabs))

## [0.3.2] - 20 April 2021

* Add optional feedback widget to items (thanks [@svoza10](https://github.com/svoza10)).

## [0.3.1] - 15 April 2021

* Fix scrolling in wrong direction when text direction is right-to-left.
* Fix drag-and-drop feedback widget alignment when text direction is right-to-left.

## [0.3.0+1] - 2 April 2021

* Fix null crash and wrong drag handle used (thanks [@vbuberen](https://github.com/vbuberen)).

## [0.3.0] - 30 March 2021

* DragHandle moved to own widget. To create any drag handle, use the new properties `listDragHandle` and `itemDragHandle` in `DragAndDropLists`.
* Support null safety, see [details on migration](https://dart.dev/null-safety/migration-guide).

## [0.2.10] - 14 December 2020

* Bug fix where `listDecorationWhileDragging` wasn't always being applied.
* Allow DragAndDropLists to be contained in an external ListView when `disableScrolling` is set to `true`.

## [0.2.9+2] - 17 November 2020

* Prevent individual lists inside of a horizontal DragAndDropLists from scrolling when `disableScrolling` is set to true.

## [0.2.9+1] - 13 November 2020

* Bug fix to also not allow scrolling when `disableScrolling` is set to true when dragging and dropping items.

## [0.2.9] - 9 November 2020

* Added `disableScrolling` parameter to `DragAndDropLists`.

## [0.2.8] - 6 November 2020

* Added `listDividerOnLastChild` parameter to `DragAndDropLists`. This allows not showing a list divider after the last list (thanks [@Zexuz](https://github.com/Zexuz)).

## [0.2.7] - 21 October 2020

* Added `onItemDraggingChanged` and `onListDraggingChanged` parameters to `DragAndDropLists`. This allows certain use cases where it is useful to be notified when dragging starts and ends
* Refactored `DragAndDropItemWrapper` to accept a `DragAndDropBuilderParameters` instead of all the other parameters independently to allow for simpler and more consistent changes

## [0.2.6] - 20 October 2020

* Always check mounted status when setting state

## [0.2.5] - 15 October 2020

* Added `constrainDraggingAxis` parameter in `DragAndDropLists`. This is useful when setting custom drag targets outside of the DragAndDropLists.

## [0.2.4] - 15 October 2020

* Added drag handle vertical alignment customization. See `listDragHandleVerticalAlignment` and `itemDragHandleVerticalAlignment` parameters in `DragAndDropLists`
* Added mouse cursor change on web when hovering on drag handle
* Fixed [itemDecorationWhileDragging only applied when dragHandle is provided?](https://github.com/philip-brink/DragAndDropLists/issues/11) (thanks [kjmj](https://github.com/kjmj))
* Fixed bug where setState() was called after dispose when dragging items in a long list (See issue [Error in debug console when dragging item in long list](https://github.com/philip-brink/DragAndDropLists/issues/9), thanks [mivoligo](https://github.com/mivoligo))
* Apply the itemDivider property to items in the DragAndDropListExpansion widget and use the lastItemTargetHeight instead of the constant value of 20 (thanks [kjmj](https://github.com/kjmj))

## [0.2.3] - 8 October 2020

* Added `disableTopAndBottomBorders` parameter to `DragAndDropListExpansion` and `ProgrammaticExpansionTile` to allow for more styling options.

## [0.2.2] - 7 October 2020

* Added function parameters for customizing the criteria for where an item or list can be dropped. See the parameters `listOnWillAccept`, `listTargetOnWillAccept`, `itemOnWillAccept` and `itemTargetOnWillAccept` in `DragAndDropLists`
* Added function parameters for directly accessing items or lists that have been dropped. See the parameters `listOnAccept`, `listTargetOnAccept`, `itemOnAccept` and `itemTargetOnAccept` in `DragAndDropLists`

## [0.2.1] - 6 October 2020

* Fixed bug where auto scrolling could occur even when not dragging an item (thanks [@ElenaKova](https://github.com/ElenaKova))

## [0.2.0] - 5 October 2020

* Added option for drag handles. See `dragHandle` and `dragHandleOnLeft` parameters in `DragAndDropLists`
* Added new example for drag handles
* Added option for item dividers. See the `itemDivider` parameter in `DragAndDropLists`
* Added option for inner list box decoration. See the `listInnerDecoration` parameter in `DragAndDropLists`
* Added option for decoration while dragging lists and items. See the `itemDecorationWhileDragging` and `itemDecorationWhileDragging` parameters in `DragAndDropLists`
* Removed unused `itemDecoration` parameter in `DragAndDropLists`
* Fixed unused `itemDraggingWidth` parameter in `DragAndDropLists`
* Configurable bottom padding for list and items. See the `lastItemTargetHeight`, `addLastItemTargetHeightToTop` and `lastListTargetSize` parameters in `DragAndDropLists`
* Remove `pubspec.lock` (thanks [@freitzzz](https://github.com/freitzzz))

## [0.1.0] - 21 September 2020

* Added canDrag option for lists
* **Interface Change:** Any classes implementing `DragAndDropListInterface` need to add `canDrag` 

## [0.0.6] - 24 July 2020

* Fixed wrong parameter order for onItemAdd (thanks [@khauns](https://github.com/khauns))
* ProgrammaticExpansionTile: include option for isThreeLine of ListTile
* ProgrammaticExpansionTile: Remove required annotation for leading

## [0.0.5] - 24 July 2020

* ProgrammaticExpansionTile: ensure that parent widget will always know its expanded/collapsed state

## [0.0.4] - 21 July 2020

* Updated example project for web compatibility

## [0.0.3] - 21 July 2020
 
* Formatted all with dartfmt
 
## [0.0.2] - 21 July 2020

* Added API documentation

## [0.0.1] - 21 July 2020

* Initial release
