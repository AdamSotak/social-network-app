import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/profile_pages/edit_profile_page.dart';
import 'package:social_network/pages/profile_pages/settings_page.dart';
import 'package:social_network/storage/app_theme/theme_mode_change_notifier.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/listview_widgets/albums_listview.dart';
import 'package:social_network/widgets/listview_widgets/posts_listview.dart';
import 'package:social_network/widgets/listview_widgets/songs_listview.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
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
  late bool localUser = widget.userId == Auth().getUserId();

  @override
  Widget build(BuildContext context) {
    var userId = widget.userId;
    var backButton = widget.backButton;

    UserData userData = UserData(
      id: "",
      username: "",
      displayName: "",
      profilePhotoURL: "",
      followers: 0,
      following: 0,
    );

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

    void openSettingsPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const SettingsPage()));
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
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
                                              children: const [
                                                MainBackButton(),
                                                SizedBox(
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
                                  const MainBackButton(),
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
                    FutureBuilder<UserData>(
                      future: UserDataDatabase().getUserData(userId),
                      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        userData = snapshot.data!;

                        return Center(
                          child: SizedBox(
                            height: 250.0,
                            child: Column(
                              children: [
                                Container(
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
                                SizedBox(
                                  width: 200.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${userData.followers} Followers",
                                        style: Theme.of(context).textTheme.headline2,
                                      ),
                                      Text(
                                        "${userData.following} Following",
                                        style: Theme.of(context).textTheme.headline2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ];
          },
          body: Column(
            children: [
              TabBar(
                indicator: MainCircleTabIndicator(
                    color: ThemeModeChangeNotifier().darkMode ? Colors.white : Colors.black, radius: 3.0),
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
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
