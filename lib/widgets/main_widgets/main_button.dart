import 'package:flutter/material.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class MainButton extends StatefulWidget {
  const MainButton(
      {Key? key,
      required this.text,
      this.icon,
      this.width = 0.0,
      this.height = 0.0,
      this.margin = const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      this.padding = const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
      required this.onPressed})
      : super(key: key);

  final String text;
  final Icon? icon;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function onPressed;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  // Builds a MainButton widget
  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var icon = widget.icon;
    var width = widget.width;
    var height = widget.height;
    var margin = widget.margin;
    var padding = widget.padding;
    var onPressed = widget.onPressed;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: MainContainer(
        width: (width != 0.0) ? width : null,
        height: (height != 0.0) ? height : null,
        margin: margin,
        pressable: true,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (icon != null) ? icon : Container(),
              Text(
                text,
                style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
