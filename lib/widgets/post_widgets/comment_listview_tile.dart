import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/comments_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/comment.dart';
import 'package:social_network/widgets/linked_text.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

// ListView tile for displaying a Comment

class CommentListViewTile extends StatelessWidget {
  const CommentListViewTile({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    // Delete the Comment from the database
    void deleteComment() {
      if (comment.userId != Auth().getUserId()) {
        return;
      }

      DialogManager().displayConfirmationDialog(
        context: context,
        onConfirmation: () {
          DialogManager().displayLoadingDialog(context: context);

          CommentsDatabase().deleteComment(comment);
          DialogManager().closeDialog(context: context);
        },
        onCancellation: () {},
      );
    }

    return MainContainer(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (comment.userId == Auth().getUserId())
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserDataWidget(userId: comment.userId),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: MainIconButton(icon: const Icon(CupertinoIcons.delete), onPressed: deleteComment),
                    )
                  ],
                )
              : UserDataWidget(userId: comment.userId),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: LinkedText(
              comment.text,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
