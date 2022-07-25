import 'package:flutter/cupertino.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class MainBackButton extends StatelessWidget {
  const MainBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: const MainContainer(
        width: 50.0,
        height: 50.0,
        pressable: true,
        margin: EdgeInsets.all(5.0),
        child: Padding(padding: EdgeInsets.all(5.0), child: Icon(CupertinoIcons.arrow_left)),
      ),
    );
  }
}
