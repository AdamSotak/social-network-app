import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/post_database.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_button.dart';
import 'package:social_network/widgets/main_text_field.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController postDescriptionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Choose post video
    void chooseImage() {}

    // Choose post image
    void chooseVideo() {}

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

      await PostDatabase().addPost(post);
    }

    return Scaffold(
      appBar: const MainAppBar(title: "Add Post"),
      body: Center(
        child: Column(
          children: [
            MainTextField(
              controller: postDescriptionTextEditingController,
              hintText: "Description",
            ),
            MainButton(text: "Choose Image", onPressed: chooseImage),
            MainButton(text: "Choose Video", onPressed: chooseVideo),
            MainButton(text: "Add Post", onPressed: addPost)
          ],
        ),
      ),
    );
  }
}
