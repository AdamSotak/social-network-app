import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/database/likes_database.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/database/playlists_database.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/models/like.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/pages/comment_pages/comments_page.dart';
import 'package:social_network/pages/edit_pages/edit_album_page.dart';
import 'package:social_network/pages/edit_pages/edit_post_page.dart';
import 'package:social_network/pages/edit_pages/edit_song_page.dart';
import 'package:social_network/pages/playlists_pages/playlists_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

// Row widget with like, comment, add to playlist and post options functionality

class OptionsRow extends StatefulWidget {
  const OptionsRow({
    Key? key,
    required this.dataType,
    this.loop,
    this.post,
    this.song,
    this.album,
    required this.preview,
    this.onDelete,
  }) : super(key: key);

  final DataType dataType;
  final Loop? loop;
  final Post? post;
  final Song? song;
  final Album? album;
  final bool preview;
  final Function? onDelete;

  @override
  State<OptionsRow> createState() => _OptionsRowState();
}

class _OptionsRowState extends State<OptionsRow> {
  bool liked = false;
  StreamController<Map<String, bool>> streamController = StreamController();
  // Setup values according to the DataType
  late String postId = (widget.dataType == DataType.loop)
      ? widget.loop!.id
      : (widget.dataType == DataType.post)
          ? widget.post!.id
          : (widget.dataType == DataType.song)
              ? widget.song!.id
              : (widget.dataType == DataType.album)
                  ? widget.album!.id
                  : "";

  late String userId = (widget.dataType == DataType.loop)
      ? widget.loop!.userId
      : (widget.dataType == DataType.post)
          ? widget.post!.userId
          : (widget.dataType == DataType.song)
              ? widget.song!.userId
              : (widget.dataType == DataType.album)
                  ? widget.album!.userId
                  : "";

  late int likes = (widget.dataType == DataType.loop)
      ? widget.loop!.likes
      : (widget.dataType == DataType.post)
          ? widget.post!.likes
          : (widget.dataType == DataType.song)
              ? widget.song!.likes
              : (widget.dataType == DataType.album)
                  ? widget.album!.likes
                  : 0;

  // Check if post was liked by the current user
  Future<void> load() async {
    try {
      bool likedValue = await LikesDatabase().checkIfLiked(postId: postId, userId: Auth().getUserId());
      streamController.add({"liked": likedValue, "buttonEnabled": true});
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant OptionsRow oldWidget) {
    load();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    load();
    super.initState();
    // Setup values according to the DataType
    switch (widget.dataType) {
      case DataType.loop:
        postId = widget.loop!.id;
        likes = widget.loop!.likes;
        break;
      case DataType.post:
        postId = widget.post!.id;
        likes = widget.post!.likes;
        break;
      case DataType.song:
        postId = widget.song!.id;
        likes = widget.song!.likes;
        break;
      case DataType.album:
        postId = widget.album!.id;
        likes = widget.album!.likes;
        break;
    }
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataType = widget.dataType;
    var loop = widget.loop;
    var post = widget.post;
    var song = widget.song;
    var album = widget.album;
    var preview = widget.preview;
    var onDelete = widget.onDelete;

    // Updates the post with the new likes count
    void updatePost(int increment) async {
      switch (dataType) {
        case DataType.loop:
          var loopValue = await LoopsDatabase().getLoop(loopId: loop!.id);
          loopValue.likes += increment;
          await LoopsDatabase().editLoop(loopValue);
          break;
        case DataType.post:
          var postValue = await PostsDatabase().getPost(postId: post!.id);
          postValue.likes += increment;
          await PostsDatabase().editPost(postValue);
          break;
        case DataType.song:
          var songValue = await SongsDatabase().getSong(songId: song!.id);
          songValue.likes += increment;
          await SongsDatabase().editSong(songValue);
          break;
        case DataType.album:
          var albumValue = await AlbumsDatabase().getAlbum(albumId: album!.id);
          albumValue.likes += increment;
          await AlbumsDatabase().editAlbum(albumValue);
          break;
      }
    }

    // Likes the post
    void like() async {
      streamController.add({"liked": false, "buttonEnabled": false});
      Like like = Like(
        id: Auth.getUUID(),
        userId: Auth().getUserId(),
        postId: postId,
        created: DateTime.now(),
      );

      await LikesDatabase().addLike(like).then((value) {
        setState(() {
          liked = true;
          likes++;
        });
        updatePost(1);
      });
      streamController.add({"liked": true, "buttonEnabled": true});
    }

    // Unlikes the post
    void unlike() async {
      streamController.add({"liked": true, "buttonEnabled": false});
      await LikesDatabase().deleteLike(postId: postId, userId: Auth().getUserId());
      setState(() {
        liked = false;
        likes--;
      });
      updatePost(-1);
      streamController.add({"liked": false, "buttonEnabled": true});
    }

    // Open comments
    void openCommentsPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => CommentsPage(postId: postId),
        ),
      );
    }

    void edit() {
      switch (dataType) {
        case DataType.loop:
          break;
        case DataType.post:
          Navigator.push(context, CupertinoPageRoute(builder: (builder) => EditPostPage(post: post!)));
          break;
        case DataType.song:
          Navigator.push(context, CupertinoPageRoute(builder: (builder) => EditSongPage(song: song!)));
          break;
        case DataType.album:
          Navigator.push(context, CupertinoPageRoute(builder: (builder) => EditAlbumPage(album: album!)));
          break;
      }
    }

    // Depending on the dataType, deletes the post
    void delete() {
      switch (dataType) {
        case DataType.loop:
          if (loop!.userId != Auth().getUserId()) return;

          DialogManager().displayConfirmationDialog(
            context: context,
            title: "Delete Loop?",
            description: "Confirm loop deletion",
            onConfirmation: () {
              LoopsDatabase().deleteLoop(loop);
              if (onDelete != null) {
                onDelete();
              }
            },
            onCancellation: () {},
          );
          break;
        case DataType.post:
          if (post!.userId != Auth().getUserId()) return;

          DialogManager().displayConfirmationDialog(
            context: context,
            title: "Delete Post?",
            description: "Confirm post deletion",
            onConfirmation: () {
              PostsDatabase().deletePost(post);
            },
            onCancellation: () {},
          );
          break;
        case DataType.song:
          if (song!.userId != Auth().getUserId()) return;

          DialogManager().displayConfirmationDialog(
            context: context,
            title: "Delete Song?",
            description: "Confirm song deletion",
            onConfirmation: () {
              SongsDatabase().deleteSong(song);
            },
            onCancellation: () {},
          );
          break;
        case DataType.album:
          if (album!.userId != Auth().getUserId()) return;

          DialogManager().displayConfirmationDialog(
            context: context,
            title: "Delete Album?",
            description: "Confirm album deletion",
            onConfirmation: () {
              AlbumsDatabase().deleteAlbum(album);
            },
            onCancellation: () {},
          );
          break;
      }
    }

    // Display Post options modalBottomSheet
    void displayPostOptions() {
      DialogManager().displayModalBottomSheet(
          context: context,
          title: "${Styles.getDataTypeString(dataType)} Options",
          options: (dataType != DataType.loop)
              ? [
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.wand_stars,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text("Edit", style: Theme.of(context).textTheme.headline4),
                    onTap: () {
                      Navigator.pop(context);
                      edit();
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
                      delete();
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
                ]
              : [
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.delete,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text("Delete", style: Theme.of(context).textTheme.headline4),
                    onTap: () {
                      Navigator.pop(context);
                      delete();
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

    // Creates a new playlist and adds the songs
    void createPlaylist() async {
      if (dataType == DataType.song && song != null) {
        DialogManager().displayLoadingDialog(context: context);

        Playlist playlist = Playlist(
          id: Auth.getUUID(),
          userId: Auth().getUserId(),
          name: song.name,
          songs: [song.id],
          created: DateTime.now(),
        );

        await PlaylistsDatabase().addPlaylist(playlist).then((value) {
          DialogManager().closeDialog(context: context);
          DialogManager().displaySnackBar(context: context, text: "Playlist has been created");
        });
      } else if (dataType == DataType.album && album != null) {
        DialogManager().displayLoadingDialog(context: context);

        Playlist playlist = Playlist(
          id: Auth.getUUID(),
          userId: Auth().getUserId(),
          name: album.name,
          songs: album.songs,
          created: DateTime.now(),
        );

        await PlaylistsDatabase().addPlaylist(playlist).then((value) {
          DialogManager().closeDialog(context: context);
          DialogManager().displaySnackBar(context: context, text: "Playlist has been created");
        });
      }
    }

    // Select a playlist and merge the songs, depends on dataType
    void selectPlaylist() {
      DialogManager().displayModalBottomSheet(context: context, title: "Add To Playlist", options: [
        ListTile(
          leading: Icon(
            CupertinoIcons.add_circled,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("New Playlist", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            createPlaylist();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            CupertinoIcons.music_albums,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Select Playlist", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (builder) => PlaylistsPage(
                  select: true,
                  dataType: dataType,
                  song: (dataType == DataType.song) ? song : null,
                  album: (dataType == DataType.album) ? album : null,
                ),
              ),
            );
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

    // Render a preview widget or a StreamBuilder with data from Firebase
    return preview
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  (likes == 1) ? "$likes Like" : "$likes Likes",
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0),
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
                        toggleButton: true,
                        toggled: false,
                        onPressed: () {},
                      ),
                      MainIconButton(
                        icon: Icon(
                          CupertinoIcons.bubble_left,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () {},
                      ),
                      (dataType == DataType.song || dataType == DataType.album)
                          ? MainIconButton(
                              icon: Icon(
                                CupertinoIcons.music_albums,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {},
                            )
                          : Container()
                    ],
                  ),
                  MainIconButton(
                    icon: Icon(
                      CupertinoIcons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          )
        : StreamBuilder<Map<String, bool>>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              liked = snapshot.data!['liked']!;
              bool buttonEnabled = snapshot.data!['buttonEnabled']!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      (likes == 1) ? "$likes Like" : "$likes Likes",
                      style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0),
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
                          liked
                              ? MainIconButton(
                                  icon: const Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.red,
                                  ),
                                  toggleButton: true,
                                  toggled: true,
                                  onPressed: buttonEnabled ? unlike : () {},
                                )
                              : MainIconButton(
                                  icon: const Icon(
                                    CupertinoIcons.heart,
                                    color: Colors.red,
                                  ),
                                  toggleButton: true,
                                  toggled: false,
                                  onPressed: buttonEnabled ? like : () {},
                                ),
                          MainIconButton(
                            icon: Icon(
                              CupertinoIcons.bubble_left,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: openCommentsPage,
                          ),
                          (dataType == DataType.song || dataType == DataType.album)
                              ? MainIconButton(
                                  icon: Icon(
                                    CupertinoIcons.music_albums,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onPressed: selectPlaylist,
                                )
                              : Container()
                        ],
                      ),
                      (userId == Auth().getUserId())
                          ? MainIconButton(
                              icon: Icon(
                                CupertinoIcons.settings,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: (preview) ? () {} : displayPostOptions,
                            )
                          : Container(),
                    ],
                  ),
                ],
              );
            },
          );
  }
}
