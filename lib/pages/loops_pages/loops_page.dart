import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/models/follow.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/music_widgets/audio_player_widget.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/options_row.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

class LoopsPage extends StatefulWidget {
  const LoopsPage({Key? key, required this.follows, required this.userId}) : super(key: key);

  final List<Follow> follows;
  final String userId;

  @override
  State<LoopsPage> createState() => _LoopsPageState();
}

class _LoopsPageState extends State<LoopsPage> {
  late bool localUser = widget.userId == Auth().getUserId();
  late final PageController pageController;
  List<Loop> loops = [];

  @override
  Widget build(BuildContext context) {
    var follows = widget.follows;
    var userId = widget.userId;

    void loopChanged(int index) {}

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: FutureBuilder<List<Loop>>(
          future: LoopsDatabase().getLoopsForUsers(users: follows.map((follow) => follow.toUserId).toList()),
          builder: (context, snapshot) {
            // Error and loading checking
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

            loops.clear();
            loops.addAll(snapshot.data!);
            loops.sort((a, b) {
              return a.created.compareTo(b.created);
            });
            pageController = PageController(initialPage: loops.indexWhere((element) => element.userId == userId));

            if (loops.isEmpty) {
              return Column(
                children: [
                  Row(
                    children: [
                      const MainBackButton(),
                      const SizedBox(width: 20.0),
                      Text("Loops", style: Theme.of(context).textTheme.headline1)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                    child: NoDataTile(
                      text: "No Loops Yet",
                      subtext: localUser ? "" :"Follow a profile or create your\nown Loop to get started",
                    ),
                  ),
                ],
              );
            }

            return PageView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.vertical,
              controller: pageController,
              onPageChanged: loopChanged,
              children: loops
                  .map((loop) => LoopPage(
                        loop: loop,
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class LoopPage extends StatelessWidget {
  const LoopPage({Key? key, required this.loop}) : super(key: key);

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    void openUserAccount() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => ProfilePage(userId: loop.userId, backButton: true),
        ),
      );
    }

    void onDelete() {
      Navigator.pop(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const MainBackButton(),
            const SizedBox(width: 20.0),
            Text("Loops", style: Theme.of(context).textTheme.headline1)
          ],
        ),
        Column(
          children: [
            MainContainer(
              pressable: true,
              onPressed: openUserAccount,
              child: UserDataWidget(userId: loop.userId),
            ),
            AudioPlayerWidget(audioPlayerType: AudioPlayerType.loop, loop: loop, preview: false),
          ],
        ),
        OptionsRow(
          dataType: DataType.loop,
          loop: loop,
          preview: false,
          onDelete: onDelete,
        )
      ],
    );
  }
}
