import 'package:flutter/cupertino.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class MainIconButton extends StatelessWidget {
  const MainIconButton({
    Key? key,
    required this.icon,
    this.width = 50.0,
    this.height = 50.0,
    this.margin = const EdgeInsets.all(5.0),
    required this.onPressed,
    this.gradient = const LinearGradient(colors: []),
  }) : super(key: key);

  final Icon icon;
  final double width;
  final double height;
  final EdgeInsets margin;
  final Function onPressed;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: MainContainer(
        width: width,
        height: width,
        pressable: true,
        gradient: (gradient != const LinearGradient(colors: [])) ? gradient : null,
        margin: margin,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: icon,
        ),
      ),
    );
  }
}
