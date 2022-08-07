import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/follows_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/follow.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/loops_pages/loops_page.dart';
import 'package:social_network/pages/profile_pages/edit_profile_page.dart';
import 'package:social_network/pages/profile_pages/follows_page.dart';
import 'package:social_network/pages/profile_pages/settings_page.dart';
import 'package:social_network/storage/app_theme/theme_mode_change_notifier.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/listview_widgets/albums_listview.dart';
import 'package:social_network/widgets/listview_widgets/likes_listview.dart';
import 'package:social_network/widgets/listview_widgets/posts_listview.dart';
import 'package:social_network/widgets/listview_widgets/songs_listview.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_circle_tab_indicator.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/main_widgets/main_scroll_behavior.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userId, this.backButton = false}) : super(key: key);

  final String userId;
  final bool backButton;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool following = false;
  StreamController<Map<String, bool>> streamController = StreamController();
  late bool localUser = widget.userId == Auth().getUserId();
  UserData userData = UserData(
    id: "",
    username: "",
    displayName: "",
    profilePhotoURL: "",
    followers: 0,
    following: 0,
  );

  // Load user data
  Future<void> getUserData() async {
    userData = await UserDataDatabase().getUserData(widget.userId);
  }

  // Check if the currentUser is following the ProfilePage account
  Future<void> checkFollowing() async {
    var followingValue =
        await FollowsDatabase().checkIfFollowed(fromUserId: Auth().getUserId(), toUserId: widget.userId);
    streamController.add({"following": followingValue, "buttonEnabled": true});
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    checkFollowing();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    checkFollowing();
    super.initState();
    getUserData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userId = widget.userId;
    var backButton = widget.backButton;

    // Open FollowersPage
    void openFollowersPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => FollowsPage(userId: userId, followers: true),
        ),
      );
    }

    // Open FollowingsPage
    void openFollowingsPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => FollowsPage(userId: userId, followers: false),
        ),
      );
    }

    // Update UserData in the database
    void updateUserData(int increment) async {
      var localUserData = await UserDataDatabase().getUserData(Auth().getUserId());
      localUserData.following += increment;

      await UserDataDatabase().editUserData(userData);
      await UserDataDatabase().editUserData(localUserData);
    }

    // Open Loops Page with the current profile
    void openLoopsPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => LoopsPage(
            follows: [Follow(id: "", userId: "", toUserId: userId, created: DateTime.now())],
            userId: userId,
          ),
        ),
      );
    }

    // Follow the account and update the UI
    void follow() async {
      streamController.add({"following": false, "buttonEnabled": false});
      Follow follow = Follow(
        id: Auth.getUUID(),
        userId: Auth().getUserId(),
        toUserId: userId,
        created: DateTime.now(),
      );
      await FollowsDatabase().addFollow(follow).then((value) {
        setState(() {
          following = true;
          userData.followers++;
        });
        updateUserData(1);
      });
      streamController.add({"following": true, "buttonEnabled": true});
    }

    // Unfollow the account and update the UI
    void unfollow() async {
      streamController.add({"following": true, "buttonEnabled": false});
      await FollowsDatabase().deleteFollow(fromUserId: Auth().getUserId(), toUserId: userId).then((value) {
        setState(() {
          following = false;
          userData.followers--;
        });
        updateUserData(-1);
      });
      streamController.add({"following": false, "buttonEnabled": true});
    }

    // Open EditPage
    void openEditPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => EditProfilePage(
            userData: userData,
          ),
        ),
      ).then((value) {
        setState(() {});
      });
    }

    // Open SettingsPage
    void openSettingsPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const SettingsPage()));
    }

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                        child: localUser
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      backButton
                                          ? Row(
                                              children: [
                                                MainBackButton(buildContext: context),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      Text(
                                        "Profile",
                                        style: Theme.of(context).textTheme.headline1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MainIconButton(
                                          icon: const Icon(CupertinoIcons.wand_stars), onPressed: openEditPage),
                                      MainIconButton(
                                          icon: const Icon(CupertinoIcons.settings), onPressed: openSettingsPage),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MainBackButton(buildContext: context),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "Profile",
                                    style: Theme.of(context).textTheme.headline1,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: localUser ? 250.0 : 300.0,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: openLoopsPage,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  gradient: Styles.linearGradients[2],
                                  borderRadius: BorderRadius.circular(150.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(150.0),
                                  ),
                                  child: (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                                      ? const CircleAvatar(
                                          backgroundImage: AssetImage(Variables.defaultProfileImageURL),
                                          backgroundColor: Styles.defaultImageBackgroundColor,
                                          radius: 70.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(userData.profilePhotoURL),
                                          backgroundColor: Styles.defaultImageBackgroundColor,
                                          radius: 70.0,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              userData.displayName,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              "@${userData.username}",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: openFollowersPage,
                                  child: Text(
                                    "${Styles.getFormattedNumberString(userData.followers)} Followers",
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                GestureDetector(
                                  onTap: openFollowingsPage,
                                  child: Text(
                                    "${Styles.getFormattedNumberString(userData.following)} Following",
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            localUser
                                ? Container()
                                : StreamBuilder<Map<String, bool>>(
                                    stream: streamController.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      following = snapshot.data!['following']!;
                                      bool buttonEnabled = snapshot.data!['buttonEnabled']!;

                                      return SizedBox(
                                        width: 200.0,
                                        child: MainButton(
                                          text: following ? "Following" : "Follow",
                                          toggleButton: true,
                                          toggled: following,
                                          onPressed: buttonEnabled
                                              ? following
                                                  ? unfollow
                                                  : follow
                                              : () {},
                                        ),
                                      );
                                    },
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ];
          },
          body: Column(
            children: [
              TabBar(
                onTap: (index) {
                  if (index == 3) {
                    setState(() {});
                  }
                },
                indicator: MainCircleTabIndicator(
                    color: ThemeModeChangeNotifier().darkMode ? Colors.white : Colors.black, radius: 3.0),
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                tabs: [
                  Tab(
                    icon: Icon(
                      CupertinoIcons.camera,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      CupertinoIcons.music_note_2,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      CupertinoIcons.music_albums,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const Tab(
                    icon: Icon(
                      CupertinoIcons.heart_fill,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MainScrollBehavior(),
                  child: TabBarView(
                    children: [
                      PostsListView(userId: userId),
                      SongsListView(userId: userId),
                      AlbumsListView(userId: userId),
                      LikesListView(userId: userId)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
