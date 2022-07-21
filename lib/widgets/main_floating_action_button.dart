import 'package:flutter/material.dart';
import 'package:social_network/styling/styles.dart';

class MainFloatingActionButton extends StatefulWidget {
  const MainFloatingActionButton({Key? key, required this.icon, required this.onPressed, this.scale = 1.0})
      : super(key: key);

  final IconData icon;
  final Function onPressed;
  final double scale;

  @override
  State<MainFloatingActionButton> createState() => _MainFloatingActionButtonState();
}

class _MainFloatingActionButtonState extends State<MainFloatingActionButton> {
  // Builds a MainFloatingActionButton widget
  @override
  Widget build(BuildContext context) {
    var icon = widget.icon;
    var onPressed = widget.onPressed;
    var scale = widget.scale;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: scale * 55.0,
      height: scale * 55.0,
      decoration: BoxDecoration(
          color: Styles.accentColor,
          boxShadow: [Styles.boxShadow],
          borderRadius: BorderRadius.circular(Styles.mainButtonBorderRadius)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Styles.mainButtonBorderRadius),
          onTap: () {
            onPressed();
          },
          splashColor: Styles.splashColor,
          child: Visibility(
            visible: (scale == 1.0) ? true : false,
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
