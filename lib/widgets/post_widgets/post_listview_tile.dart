import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';
import 'package:video_player/video_player.dart';

class PostListViewTile extends StatefulWidget {
  const PostListViewTile({Key? key, required this.post, this.onContentURLCleared}) : super(key: key);

  final Post post;
  final Function? onContentURLCleared;

  @override
  State<PostListViewTile> createState() => _PostListViewTileState();
}

class _PostListViewTileState extends State<PostListViewTile> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoPlayerController;
  late bool preview = widget.post.id == "preview";
  UserData userData = UserData(
    id: "",
    username: "",
    displayName: "",
    profilePhotoURL: "",
    followers: 0,
    following: 0,
  );

  Future<void> getUserData() async {
    userData = await UserDataDatabase().getUserData(widget.post.userId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getUserData().whenComplete(() {
      setState(() {});
    });
    _videoPlayerController = VideoPlayerController.network(widget.post.contentURL)
      ..initialize().then(
        (value) {
          setState(() {
            _videoPlayerController.setLooping(true);
            _videoPlayerController.play();
          });
        },
      );
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
    var onContentURLCleared = widget.onContentURLCleared;

    void setupVideoPlayer() async {
      if (preview && post.contentURL != "" && post.video) {
        _videoPlayerController.dispose();
        _videoPlayerController = VideoPlayerController.file(File(widget.post.contentURL));
        await _videoPlayerController.initialize();
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        log(_videoPlayerController.value.size.height.toString());
      }
    }

    setupVideoPlayer();

    // Delete Post from database
    void deletePost() {
      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Delete Post?",
        description: "Confirm post deletion",
        onConfirmation: () {
          PostsDatabase().deletePost(post);
        },
        onCancellation: () {},
      );
    }

    void deletePostContentURL() {
      setState(() {
        post.contentURL = "";
      });

      if (post.video) {
        _videoPlayerController.dispose();
      }

      if (onContentURLCleared != null) {
        onContentURLCleared();
      }
    }

    // Display Post options modalBottomSheet
    void displayPostOptions() {
      DialogManager().displayModalBottomSheet(context: context, title: "Post Options", options: [
        ListTile(
          leading: Icon(
            CupertinoIcons.wand_stars,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Edit", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            CupertinoIcons.delete,
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
            CupertinoIcons.xmark,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Close", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ]);
    }

    Widget buildPostListViewTile(UserData userData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserDataWidget(userData: userData, created: post.created),
          const SizedBox(
            height: 20.0,
          ),
          (post.contentURL != "" && !post.video)
              ? (preview)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.file(File(post.contentURL))),
                        MainIconButton(icon: const Icon(CupertinoIcons.delete), onPressed: deletePostContentURL)
                      ],
                    )
                  : ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.network(post.contentURL))
              : Container(),
          (post.contentURL != "" && post.video)
              ? (preview)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), child: VideoPlayer(_videoPlayerController)),
                        ),
                        MainIconButton(icon: const Icon(CupertinoIcons.delete), onPressed: deletePostContentURL)
                      ],
                    )
                  : AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), child: VideoPlayer(_videoPlayerController)),
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
                      ),
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
                  MainIconButton(
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                  MainIconButton(
                    icon: Icon(
                      CupertinoIcons.bubble_left,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                  MainIconButton(
                    icon: Icon(
                      CupertinoIcons.bookmark,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              MainIconButton(
                icon: Icon(
                  CupertinoIcons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: (preview) ? () {} : displayPostOptions,
              ),
            ],
          ),
        ],
      );
    }

    return MainContainer(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.only(bottom: 5.0),
        child: buildPostListViewTile(userData));
  }
}
