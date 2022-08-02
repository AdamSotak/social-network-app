import 'package:flutter/cupertino.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class MainBackButton extends StatelessWidget {
  const MainBackButton({Key? key, required this.buildContext}) : super(key: key);

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return MainIconButton(
      icon: const Icon(CupertinoIcons.arrow_left),
      onPressed: () {
        Navigator.pop(buildContext);
      },
    );
  }
}
