import 'package:drag_and_drop_lists/draggable_item.dart';
import 'package:flutter/widgets.dart';

class DraggableListContents extends StatelessWidget {
  final Widget header;
  final Widget footer;
  final Widget leftSide;
  final Widget rightSide;
  final Decoration decoration;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;
  final List<DraggableItem> children;

  DraggableListContents(
      {this.children,
      this.header,
      this.footer,
      this.leftSide,
      this.rightSide,
      this.decoration,
      this.horizontalAlignment,
      this.verticalAlignment,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContents();
  }

  Widget _buildContents() {
    return Container(
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: verticalAlignment,
        children: _generateContents(),
      ),
    );
  }

  List<Widget> _generateContents() {
    var contents = List<Widget>();
    if (header != null) {
      contents.add(Flexible(child: header));
    }
    contents.add(
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: horizontalAlignment,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _generateInnerContents(),
        ),
      ),
    );
    if (footer != null) {
      contents.add(Flexible(child: footer));
    }
    return contents;
  }

  List<Widget> _generateInnerContents() {
    var contents = List<Widget>();
    if (leftSide != null) {
      contents.add(leftSide);
    }
    if (children != null) {
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: verticalAlignment,
              mainAxisSize: MainAxisSize.max,
              children: children,
            ),
          ),
        ),
      );
    }
    if (rightSide != null) {
      contents.add(rightSide);
    }
    return contents;
  }
}
