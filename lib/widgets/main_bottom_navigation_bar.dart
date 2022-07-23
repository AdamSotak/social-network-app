import 'dart:ui';

import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.only(top: 4.0),
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
  const MainBottomNavigationBarItem({Key? key, required this.icon, this.title = const Text("")}) : super(key: key);

  final Icon icon;
  final Text title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0,
      height: 70.0,
      child: Column(
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
