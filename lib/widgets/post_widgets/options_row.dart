import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class OptionsRow extends StatelessWidget {
  const OptionsRow({
    Key? key,
    required this.preview,
    this.playlist = false,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final bool preview;
  final bool playlist;
  final Function onEdit;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
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
            onEdit();
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
            onDelete();
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

    return Row(
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
            playlist
                ? MainIconButton(
                    icon: Icon(
                      CupertinoIcons.music_albums,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  )
                : MainIconButton(
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
    );
  }
}
