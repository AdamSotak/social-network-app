import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class OptionsRow extends StatelessWidget {
  const OptionsRow({
    Key? key,
    required this.preview,
    this.song = false,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final bool preview;
  final bool song;
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
        IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: Row(
            children: [
              MainIconButton(
                icon: const Icon(
                  CupertinoIcons.heart,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
              MainIconButton(
                icon: const Icon(
                  CupertinoIcons.bubble_left,
                ),
                onPressed: () {},
              ),
              song
                  ? MainIconButton(
                      icon: const Icon(
                        CupertinoIcons.music_albums,
                      ),
                      onPressed: () {},
                    )
                  : MainIconButton(
                      icon: const Icon(
                        CupertinoIcons.bookmark,
                      ),
                      onPressed: () {},
                    ),
            ],
          ),
        ),
        MainIconButton(
          icon: const Icon(
            CupertinoIcons.settings,
          ),
          onPressed: (preview) ? () {} : displayPostOptions,
        ),
      ],
    );
  }
}
