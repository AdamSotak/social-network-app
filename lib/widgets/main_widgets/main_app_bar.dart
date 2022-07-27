import 'package:flutter/material.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class MainAppBar extends StatefulWidget {
  const MainAppBar({
    Key? key,
    required this.title,
    required this.icon,
    required this.onIconPressed,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final Function onIconPressed;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  // Builds a MainAppBar widget
  @override
  Widget build(BuildContext context) {
    var title = widget.title;
    var icon = widget.icon;
    var onIconPressed = widget.onIconPressed;

    return Row(
      children: [
        const MainBackButton(),
        const Spacer(),
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        const Spacer(),
        MainIconButton(
          icon: icon,
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          onPressed: onIconPressed,
        )
      ],
    );
  }
}
