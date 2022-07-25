import 'package:flutter/material.dart';
import 'package:social_network/styling/styles.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as box_shadow;

class MainContainer extends StatefulWidget {
  const MainContainer({
    Key? key,
    this.width = 0.0,
    this.height = 0.0,
    this.pressable = false,
    this.margin = const EdgeInsets.all(5.0),
    this.padding = const EdgeInsets.all(0.0),
    this.gradient,
    this.onEffect,
    this.onEffectEnd,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  final double? width;
  final double? height;
  final bool pressable;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final LinearGradient? gradient;
  final Function? onPressed;
  final Function? onEffect;
  final Function? onEffectEnd;
  final Widget child;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    var width = widget.width;
    var height = widget.height;
    var pressable = widget.pressable;
    var margin = widget.margin;
    var padding = widget.padding;
    var gradient = widget.gradient;
    var onPressed = widget.onPressed;
    var onEffect = widget.onEffect;
    var onEffectEnd = widget.onEffectEnd;
    var child = widget.child;

    LinearGradient pressedLinearGradient =
        LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
    ]);

    return Listener(
      onPointerUp: (event) => setState(() {
        if (!pressable) return;
        pressed = false;
        if (onEffectEnd != null) {
          onEffectEnd();
        }
        if (onPressed != null) {
          onPressed();
        }
      }),
      onPointerDown: (event) => setState(() {
        if (!pressable) return;
        pressed = true;
        if (onEffect != null) {
          onEffect();
        }
      }),
      child: AnimatedContainer(
        width: (width != 0.0) ? width : null,
        height: (height != 0.0) ? height : null,
        margin: margin,
        padding: padding,
        duration: const Duration(milliseconds: 100),
        decoration: box_shadow.BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
          color: Colors.grey[200],
          gradient: (pressed) ? pressedLinearGradient : gradient,
          boxShadow: [
            box_shadow.BoxShadow(
              color: Colors.white,
              offset: const Offset(-5.0, -5.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
              inset: pressed,
            ),
            box_shadow.BoxShadow(
                color: Colors.grey.shade600,
                offset: const Offset(5.0, 5.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
                inset: pressed),
          ],
        ),
        child: child,
      ),
    );
  }
}
