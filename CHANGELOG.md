# Changelog

## [0.2.0] - 5 October 2020

* Added option for drag handles. See `dragHandle` and `dragHandleOnLeft` parameters in `DragAndDropLists`
* Added new example for drag handles
* Added option for item dividers. See the `itemDivider` parameter in `DragAndDropLists`
* Added option for inner list box decoration. See the `listInnerDecoration` parameter in `DragAndDropLists`
* Added option for decoration while dragging lists and items. See the `itemDecorationWhileDragging` and `itemDecorationWhileDragging` parameters in `DragAndDropLists`
* Removed unused `itemDecoration` parameter in `DragAndDropLists`
* Fixed unused `itemDraggingWidth` parameter in `DragAndDropLists`
* Configurable bottom padding for list and items. See the `lastItemTargetHeight`, `addLastItemTargetHeightToTop` and `lastListTargetSize` parameters in `DragAndDropLists`
* Remove `pubspec.lock` (thanks @freitzzz)

## [0.1.0] - 21 September 2020

* Added canDrag option for lists
* **Interface Change:** Any classes implementing `DragAndDropListInterface` need to add `canDrag` 

## [0.0.6] - 24 July 2020

* Fixed wrong parameter order for onItemAdd (thanks @khauns)
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
