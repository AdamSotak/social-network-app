import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as box_shadow;
import 'package:social_network/storage/app_theme/theme_mode_change_notifier.dart';
import 'package:social_network/styling/styles.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    Key? key,
    required this.controller,
    this.decoration = const InputDecoration(),
    this.hintText = "",
    this.style = const TextStyle(),
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength = 0,
    this.autofocus = false,
    this.margin = const EdgeInsets.all(0.0),
    this.width = 500.0,
    this.height = 0.0,
    this.scrollController,
    this.onEditingComplete,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final InputDecoration decoration;
  final String hintText;
  final TextStyle? style;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final bool autofocus;
  final EdgeInsets margin;
  final double width;
  final double height;
  final ScrollController? scrollController;
  final Function? onEditingComplete;
  final Function? onChanged;

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
    var maxLength = widget.maxLength;
    var autofocus = widget.autofocus;
    var margin = widget.margin;
    var width = widget.width;
    var height = widget.height;
    var scrollController = widget.scrollController;
    var onEditingComplete = widget.onEditingComplete;
    var onChanged = widget.onChanged;

    // Custom neuromorphic TextField

    return SizedBox(
      width: (width == 0.0) ? null : width,
      height: (height == 0.0) ? null : height,
      child: Container(
        margin: margin,
        decoration: box_shadow.BoxDecoration(
          boxShadow: [
            box_shadow.BoxShadow(
              color: ThemeModeChangeNotifier().darkMode ? Colors.black : Colors.white,
              offset: const Offset(-5.0, -5.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
              inset: true,
            ),
            box_shadow.BoxShadow(
                color: ThemeModeChangeNotifier().darkMode ? Colors.grey.shade900 : Colors.grey.shade600,
                offset: const Offset(5.0, 5.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
                inset: true),
          ],
          borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
        ),
        child: TextField(
          style: style,
          controller: textFieldTextEditingController,
          decoration: decoration.copyWith(hintText: hintText),
          obscureText: obscureText,
          maxLines: (maxLines == 0) ? null : maxLines,
          maxLength: (maxLength == 0) ? null : maxLength,
          autofocus: autofocus,
          scrollController: scrollController,
          onEditingComplete: () {
            if (onEditingComplete != null) {
              onEditingComplete();
            }
          },
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
