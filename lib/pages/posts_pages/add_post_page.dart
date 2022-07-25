import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/post_database.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/storage/storage.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:video_player/video_player.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController postDescriptionTextEditingController = TextEditingController();
  String imageUrl = "";
  String videoUrl = "";
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(allowBackgroundPlayback: false);
    _videoPlayerController = VideoPlayerController.file(File(videoUrl), videoPlayerOptions: videoPlayerOptions)
      ..initialize().then(
        (value) {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Choose post video
    void chooseImage() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          videoUrl = "";
          imageUrl = image.path;
        });
      }
    }

    // Choose post image
    void chooseVideo() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          imageUrl = "";
          videoUrl = video.path;
          VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(allowBackgroundPlayback: false);
          _videoPlayerController = VideoPlayerController.file(File(videoUrl), videoPlayerOptions: videoPlayerOptions)
            ..initialize().then(
              (value) {
                setState(() {});
              },
            );
          _videoPlayerController.setLooping(true);
          _videoPlayerController.play();
        });
      }
    }

    // Add Post to database
    void addPost() async {
      if (Styles.checkIfStringEmpty(postDescriptionTextEditingController.text)) return;

      Post post = Post(
          id: Styles.getUUID(),
          userId: Auth().getUserId(),
          description: postDescriptionTextEditingController.text,
          contentURL: "",
          video: false,
          created: DateTime.now());

      if (imageUrl != "") {
        post.contentURL = await Storage().uploadPostImage(imageUrl, post.id);
        post.video = false;
      } else if (videoUrl != "") {
        post.contentURL = await Storage().uploadPostVideo(videoUrl, post.id);
        post.video = true;
      }

      await PostDatabase().addPost(post).then((value) {
        // Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: const MainAppBar(title: "Add Post"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              MainTextField(
                controller: postDescriptionTextEditingController,
                hintText: "Description",
              ),
              (imageUrl != "")
                  ? Image.file(
                      File(imageUrl),
                      height: 350.0,
                    )
                  : Container(),
              (videoUrl != "" && _videoPlayerController.value.isInitialized)
                  ? SizedBox(
                      height: 350.0,
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    )
                  : Container(),
              MainButton(text: "Choose Image", onPressed: chooseImage),
              MainButton(text: "Choose Video", onPressed: chooseVideo),
              MainButton(text: "Add Post", onPressed: addPost)
            ],
          ),
        ),
      ),
    );
  }
}
