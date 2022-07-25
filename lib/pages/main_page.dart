import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/pages/create/create_page.dart';
import 'package:social_network/pages/home_page.dart';
import 'package:social_network/pages/playlists/playlists_page.dart';
import 'package:social_network/pages/posts/add_post_page.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/widgets/main_bottom_navigation_bar.dart';

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
    AddPostPage(),
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
        widgets: const [
          MainBottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text("Home")),
          MainBottomNavigationBarItem(icon: Icon(CupertinoIcons.music_albums), title: Text("Playlists")),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: MainBottomNavigationBarItem(
                icon: Icon(
              CupertinoIcons.add_circled,
              size: 40.0,
            )),
          ),
          MainBottomNavigationBarItem(icon: Icon(CupertinoIcons.music_note), title: Text("Create")),
          MainBottomNavigationBarItem(icon: Icon(CupertinoIcons.person), title: Text("Profile")),
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
