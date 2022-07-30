import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/comments_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/comment.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class AddCommentsPage extends StatefulWidget {
  const AddCommentsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<AddCommentsPage> createState() => _AddCommentsPageState();
}

class _AddCommentsPageState extends State<AddCommentsPage> {
  final TextEditingController commentTextEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    commentTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var id = widget.id;

    void addComment() {
      if (Styles.checkIfStringEmpty(commentTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter a comment");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      Comment comment = Comment(
        id: Auth.getUUID(),
        userId: Auth().getUserId(),
        postId: id,
        text: commentTextEditingController.text,
        created: DateTime.now(),
      );

      CommentsDatabase().addComment(comment).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainAppBar(
                title: "Add Comment",
                icon: const Icon(
                  CupertinoIcons.check_mark,
                ),
                onIconPressed: addComment,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Scrollbar(
                controller: scrollController,
                child: MainTextField(
                  controller: commentTextEditingController,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  hintText: "Comment",
                  autofocus: true,
                  maxLines: 0,
                  maxLength: 1000,
                  height: 250.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
