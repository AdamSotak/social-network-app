import 'package:flutter/material.dart';
import 'package:social_network/database/post_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/styling/styles.dart';
import 'package:video_player/video_player.dart';

class PostListViewTile extends StatefulWidget {
  const PostListViewTile({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostListViewTile> createState() => _PostListViewTileState();
}

class _PostListViewTileState extends State<PostListViewTile> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.post.contentURL)
      ..initialize().then((_) {
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var post = widget.post;

    // Delete Post from database
    void deletePost() {
      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Delete Post?",
        description: "Confirm post deletion",
        onConfirmation: () {
          PostDatabase().deletePost(post);
        },
        onCancellation: () {},
      );
    }

    // Display Post options modalBottomSheet
    void displayPostOptions() {
      DialogManager().displayModalBottomSheet(context: context, title: "Post Options", options: [
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Edit", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Delete", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
            deletePost();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.close,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Close", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ]);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
        ),
        elevation: 10.0,
        child: FutureBuilder<UserData>(
          future: UserDataDatabase().getUserData(post.userId),
          builder: (context, snapshot) {
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

            UserData userData = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("development_assets/images/profile_image.jpg"),
                        radius: 25.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.displayName,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text("@${userData.username}"),
                          Text(Styles.getFormattedDateString(post.created)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                (post.contentURL != "" && !post.video)
                    ? ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.network(post.contentURL))
                    : Container(),
                (post.contentURL != "" && post.video && _videoPlayerController.value.isInitialized)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: [
                      (post.contentURL != "")
                          ? Text(
                              post.description,
                              style: Theme.of(context).textTheme.headline2,
                            )
                          : Text(
                              post.description,
                              style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0),
                            )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          splashRadius: Styles.buttonSplashRadius,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.comment,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          splashRadius: Styles.buttonSplashRadius,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bookmark,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          splashRadius: Styles.buttonSplashRadius,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: displayPostOptions,
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      splashRadius: Styles.buttonSplashRadius,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
