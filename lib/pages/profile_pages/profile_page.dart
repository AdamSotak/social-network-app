import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/listview_widgets/albums_listview.dart';
import 'package:social_network/widgets/listview_widgets/posts_listview.dart';
import 'package:social_network/widgets/listview_widgets/songs_listview.dart';
import 'package:social_network/widgets/main_widgets/main_circle_tab_indicator.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/main_widgets/main_scroll_behavior.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserData> getUserData;

  @override
  void initState() {
    super.initState();
    getUserData = UserDataDatabase().getUserData(Auth().getUserId());
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = UserData(
      id: "",
      username: "",
      displayName: "",
      profilePhotoURL: "",
      followers: 0,
      following: 0,
    );

    void openEditPage() {}

    void openSettingsPage() {}

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Row(
                              children: [
                                MainIconButton(icon: const Icon(CupertinoIcons.wand_stars), onPressed: openEditPage),
                                MainIconButton(icon: const Icon(CupertinoIcons.settings), onPressed: openSettingsPage),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder<UserData>(
                      future: getUserData,
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
                            height: 220.0,
                            child: Column(
                              children: [
                                (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(Variables.defaultProfileImageURL),
                                        radius: 70.0,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(userData.profilePhotoURL),
                                        radius: 70.0,
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
                indicator: MainCircleTabIndicator(color: Colors.black, radius: 3.0),
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                tabs: [
                  Tab(
                    icon: Icon(CupertinoIcons.camera, color: Theme.of(context).iconTheme.color),
                  ),
                  Tab(
                    icon: Icon(CupertinoIcons.music_note_2, color: Theme.of(context).iconTheme.color),
                  ),
                  Tab(
                    icon: Icon(CupertinoIcons.music_albums, color: Theme.of(context).iconTheme.color),
                  ),
                ],
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MainScrollBehavior(),
                  child: const TabBarView(
                    children: [
                      PostsListView(),
                      SongsListView(),
                      AlbumsListView(),
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
