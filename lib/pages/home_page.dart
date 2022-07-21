import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Home",
        actionButtons: [
          IconButton(
            onPressed: () {
              Auth().logout();
            },
            splashRadius: Styles.buttonSplashRadius,
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
      body: Column(),
    );
  }
}
