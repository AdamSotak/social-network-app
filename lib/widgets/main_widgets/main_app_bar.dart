import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    Key? key,
    required this.title,
    this.fontSize = 0.0,
    required this.icon,
    required this.onIconPressed,
  }) : super(key: key);

  final String title;
  final double fontSize;
  final Icon icon;
  final Function onIconPressed;

  // Builds a MainAppBar widget
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MainIconButton(
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: (fontSize == 0.0) ? 25.0 : fontSize),
            overflow: TextOverflow.fade,
          ),
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
