import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/widgets/linked_text.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/post_widgets/options_row.dart';
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
  bool videoPlayerSetup = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!preview && widget.post.video) {
      _videoPlayerController = VideoPlayerController.network(widget.post.contentURL)
        ..initialize().then(
          (value) {
            setState(() {
              _videoPlayerController.setLooping(true);
              _videoPlayerController.play();
            });
          },
        );
    } else if (preview && widget.post.video) {
      _videoPlayerController = VideoPlayerController.file(File(widget.post.contentURL))
        ..initialize().then(
          (value) {
            setState(() {
              _videoPlayerController.setLooping(true);
              _videoPlayerController.play();
            });
          },
        );
    }
  }

  @override
  void dispose() {
    try {
      _videoPlayerController.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var post = widget.post;
    var onContentURLCleared = widget.onContentURLCleared;

    void setupVideoPlayer() async {
      if (preview && post.contentURL != "" && post.video) {
        _videoPlayerController = VideoPlayerController.file(File(widget.post.contentURL))
          ..initialize().then((value) {
            setState(() {
              _videoPlayerController.setLooping(true);
              _videoPlayerController.play();
              videoPlayerSetup = true;
            });
          });
      }
    }

    if (!videoPlayerSetup) {
      setupVideoPlayer();
    }

    void deletePostContentURL() {
      setState(() {
        post.contentURL = "";
      });

      if (onContentURLCleared != null) {
        onContentURLCleared();
      }
    }

    Widget buildPostListViewTile() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserDataWidget(userId: post.userId, created: post.created),
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
                    ? LinkedText(
                        post.description,
                        style: Theme.of(context).textTheme.headline2,
                      )
                    : LinkedText(
                        post.description,
                        style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          OptionsRow(
            dataType: DataType.post,
            post: post,
            preview: preview,
          )
        ],
      );
    }

    return MainContainer(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.only(bottom: 5.0),
        child: buildPostListViewTile());
  }
}
