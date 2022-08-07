import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/post_type.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/linked_text.dart';
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
    likes: 0,
    video: false,
    hashtags: [],
    created: DateTime.now(),
  );
  String addPictureButtonText = "Add Picture";
  String addVideoButtonText = "Add Video";

  @override
  void dispose() {
    postDescriptionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var postType = widget.postType;

    // Check data and add new Post to database
    void addPost() async {
      if (Styles.checkIfStringEmpty(postDescriptionTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter post description");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      post.id = Auth.getUUID();
      post.description = postDescriptionTextEditingController.text;
      post.hashtags = LinkedTextTools.getAllHashtags(post.description);
      post.created = DateTime.now();

      await PostsDatabase().addPost(post).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    // Change post description in the preview PostListViewTile widget
    void onDescriptionChanged(String value) {
      setState(() {
        post.description = value;
      });
    }

    // Open image picker to choose post image, display the image, change button text
    void addImage() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        addPictureButtonText = "Change Picture";
        post.contentURL = image.path;
      });
    }

    // Open video picker to choose post video, display the video, change button text
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

    // Set the button text to default
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
                    height: 250.0,
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
