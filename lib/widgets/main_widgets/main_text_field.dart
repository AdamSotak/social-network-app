 import 'package:flutter/material.dart';

class MainTextField extends StatefulWidget {
  const MainTextField(
      {Key? key,
      required this.controller,
      this.decoration = const InputDecoration(),
      this.hintText = "",
      this.style = const TextStyle(),
      this.obscureText = false,
      this.maxLines = 1,
      this.autofocus = false,
      this.margin = const EdgeInsets.all(10.0),
      this.width = 500.0})
      : super(key: key);

  final TextEditingController controller;
  final InputDecoration decoration;
  final String hintText;
  final TextStyle? style;
  final bool obscureText;
  final int maxLines;
  final bool autofocus;
  final EdgeInsets margin;
  final double width;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  @override
  Widget build(BuildContext context) {
    var textFieldTextEditingController = widget.controller;
    var decoration = widget.decoration;
    var hintText = widget.hintText;
    var style = widget.style;
    var obscureText = widget.obscureText;
    var maxLines = widget.maxLines;
    var autofocus = widget.autofocus;
    var margin = widget.margin;
    var width = widget.width;

    return SizedBox(
      width: (width == 0.0) ? null : width,
      child: Container(
        margin: margin,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 10.0,
          child: TextField(
            style: style,
            controller: textFieldTextEditingController,
            decoration: decoration.copyWith(hintText: hintText),
            obscureText: obscureText,
            maxLines: maxLines,
            autofocus: autofocus,
          ),
        ),
      ),
    );
  }
}
