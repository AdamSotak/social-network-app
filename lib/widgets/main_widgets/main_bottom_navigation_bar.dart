import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as box_shadow;
import 'package:social_network/storage/app_theme/theme_mode_change_notifier.dart';
import 'package:social_network/styling/styles.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({
    Key? key,
    required this.widgets,
    required this.selectedIndex,
    required this.onWidgetSelected,
  }) : super(key: key);

  final List<Widget> widgets;
  final int selectedIndex;
  final Function onWidgetSelected;

  @override
  State<MainBottomNavigationBar> createState() => _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    var widgets = widget.widgets;
    var onWidgetSelected = widget.onWidgetSelected;
    List<Widget> newWidgets = [];

    for (int index = 0; index < widgets.length; index++) {
      newWidgets.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            onWidgetSelected(index);
          },
          child: widgets[index],
        ),
      );
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70.0, sigmaY: 70.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 75.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: newWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class MainBottomNavigationBarItem extends StatelessWidget {
  const MainBottomNavigationBarItem({
    Key? key,
    required this.icon,
    this.title = const Text(""),
    required this.selected,
    required this.index,
  }) : super(key: key);

  final Icon icon;
  final Text title;
  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70.0,
      height: 70.0,
      decoration: box_shadow.BoxDecoration(
        borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
        color: Colors.transparent,
        boxShadow: (selected)
            ? [
                box_shadow.BoxShadow(
                  color: ThemeModeChangeNotifier().darkMode ? Colors.white.withOpacity(0.7) : Colors.white,
                  offset: const Offset(-5.0, -5.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  inset: selected,
                ),
                box_shadow.BoxShadow(
                  color: Colors.grey.shade600,
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  inset: selected,
                ),
              ]
            : [],
      ),
      child: (index == 2)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  height: 5.0,
                ),
                title
              ],
            ),
    );
  }
}
