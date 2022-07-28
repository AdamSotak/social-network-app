import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/post_type.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/post_widgets/post_listview_tile.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key, required this.postType}) : super(key: key);

  final PostType postType;

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController postDescriptionTextEditingController = TextEditingController();
  Post post = Post(
    id: "preview",
    userId: Auth().getUserId(),
    description: "",
    contentURL: "",
    video: false,
    created: DateTime.now(),
  );
  String addPictureButtonText = "Add Picture";
  String addVideoButtonText = "Add Video";

  @override
  Widget build(BuildContext context) {
    var postType = widget.postType;

    void addPost() async {
      DialogManager().displayLoadingDialog(context: context);

      post.id = Auth.getUUID();
      post.description = postDescriptionTextEditingController.text;
      post.created = DateTime.now();

      await PostsDatabase().addPost(post).then((value) {
      DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });

    }

    void onDescriptionChanged(String value) {
      setState(() {
        post.description = value;
      });
    }

    void addImage() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        addPictureButtonText = "Change Picture";
        post.contentURL = image.path;
      });
    }

    void addVideo() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);

      if (video == null) return;

      setState(() {
        addVideoButtonText = "Change Video";
        post.video = true;
        post.contentURL = video.path;
      });
    }

    void resetButtonText() {
      setState(() {
        addPictureButtonText = "Add Picture";
        addVideoButtonText = "Add Video";
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Add Post",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: addPost,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostListViewTile(
                    post: post,
                    onContentURLCleared: resetButtonText,
                  ),
                  MainTextField(
                    controller: postDescriptionTextEditingController,
                    hintText: "Description",
                    onChanged: onDescriptionChanged,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  (postType == PostType.image)
                      ? MainButton(text: addPictureButtonText, onPressed: addImage)
                      : Container(),
                  (postType == PostType.video)
                      ? MainButton(text: addVideoButtonText, onPressed: addVideo)
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
