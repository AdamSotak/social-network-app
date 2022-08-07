import 'package:flutter/cupertino.dart';

// ScrollBehavior without overscroll glow

class MainScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
