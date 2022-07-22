import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/pages/posts_page.dart';
import 'package:social_network/pages/settings_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int bottomNavigationBarCurrentIndex = 0;
  late PageController pageController;

  List<Widget> pages = const [PostsPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void openAddPage() {
    Navigator.pushNamed(context, '/addpost');
  }

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
      body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                fillColor: const Color.fromARGB(50, 55, 55, 55),
                child: child,
              ),
          child: pages[bottomNavigationBarCurrentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavigationBarCurrentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
        onTap: (index) {
          setState(() {
            bottomNavigationBarCurrentIndex = index;
          });
        },
      ),
      floatingActionButton: MainFloatingActionButton(
        icon: Icons.add,
        onPressed: openAddPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
