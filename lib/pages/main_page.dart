import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/pages/add_pages/add_page.dart';
import 'package:social_network/pages/create_pages/create_page.dart';
import 'package:social_network/pages/home_page.dart';
import 'package:social_network/pages/playlists_pages/playlists_page.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/widgets/main_widgets/main_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static int bottomNavigationBarCurrentIndex = 0;
  late PageController pageController;

  List<Widget> pages = const [
    HomePage(),
    PlaylistsPage(),
    AddPage(),
    CreatePage(),
    ProfilePage(),
  ];

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
      body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                fillColor: const Color.fromARGB(50, 55, 55, 55),
                child: child,
              ),
          child: pages[bottomNavigationBarCurrentIndex]),
      bottomNavigationBar: MainBottomNavigationBar(
        widgets: [
          MainBottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            title: const Text("Home"),
            selected: (bottomNavigationBarCurrentIndex == 0),
            index: 0,
          ),
          MainBottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.music_albums),
            title: const Text("Playlists"),
            selected: (bottomNavigationBarCurrentIndex == 1),
            index: 1,
          ),
          MainBottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.add_circled,
              size: 40.0,
            ),
            selected: (bottomNavigationBarCurrentIndex == 2),
            index: 2,
          ),
          MainBottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.music_note),
            title: const Text("Create"),
            selected: (bottomNavigationBarCurrentIndex == 3),
            index: 3,
          ),
          MainBottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            title: const Text("Profile"),
            selected: (bottomNavigationBarCurrentIndex == 4),
            index: 4,
          ),
        ],
        selectedIndex: bottomNavigationBarCurrentIndex,
        onWidgetSelected: (index) {
          setState(() {
            bottomNavigationBarCurrentIndex = index;
          });
        },
      ),
    );
  }
}
