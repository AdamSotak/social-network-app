import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget with PreferredSizeWidget {
  const MainAppBar({Key? key, required this.title, this.actionButtons = const []}) : super(key: key);

  final String title;
  final List<Widget> actionButtons;

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _MainAppBarState extends State<MainAppBar> {
  // Builds a MainAppBar widget
  @override
  Widget build(BuildContext context) {
    var title = widget.title;
    var actionButtons = widget.actionButtons;

    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      leadingWidth: 50.0,
      actions: [...actionButtons],
      elevation: 0.0,
      leading: Navigator.of(context).canPop() && ModalRoute.of(context)?.settings.name != "/"
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                Navigator.of(context).pop();
              },
              splashRadius: 20.0,
            )
          : null,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(),
    );
  }
}
