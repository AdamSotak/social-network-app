import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/post_widgets/post_listview_tile.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController postDescriptionTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postDescriptionTextEditingController.text = widget.post.description;
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;

    // Check data and update the post in the database
    void editPost() async {
      if (Styles.checkIfStringEmpty(postDescriptionTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter post description");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      post.description = postDescriptionTextEditingController.text;
      post.created = DateTime.now();

      await PostsDatabase().editPost(post).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    // Update the PostListViewTile preview widget with new post description
    void onDescriptionChanged(String value) {
      setState(() {
        post.description = value;
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
                title: "Edit Post",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: editPost,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostListViewTile(
                    post: post,
                    onContentURLCleared: () {},
                  ),
                  MainTextField(
                    controller: postDescriptionTextEditingController,
                    hintText: "Description",
                    onChanged: onDescriptionChanged,
                    height: 250.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
