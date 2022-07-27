import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/enums/post_type.dart';
import 'package:social_network/pages/add_pages/add_loop_page.dart';
import 'package:social_network/pages/add_pages/add_post_page.dart';
import 'package:social_network/pages/add_pages/add_song_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            child: Text(
              "Add...",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          const AddWidget(text: "Loop", index: 0),
          const AddWidget(text: "Song", index: 1),
          const AddWidget(text: "Text", index: 2),
          const AddWidget(text: "Picture", index: 3),
          const AddWidget(text: "Video", index: 4),
        ],
      ),
    );
  }
}

class AddWidget extends StatefulWidget {
  const AddWidget({
    Key? key,
    required this.text,
    required this.index,
  }) : super(key: key);

  final String text;
  final int index;

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var index = widget.index;

    void openPage(Widget page) {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => page));
    }

    void choosePage() {
      switch (index) {
        case 0:
          openPage(const AddLoopPage());
          break;
        case 1:
          openPage(const AddSongPage());
          break;
        case 2:
          openPage(const AddPostPage(postType: PostType.text));
          break;
        case 3:
          openPage(const AddPostPage(postType: PostType.image));
          break;
        case 4:
          openPage(const AddPostPage(postType: PostType.video));
          break;
      }
    }

    return Flexible(
      child: Listener(
        onPointerUp: (event) => setState(() {
          pressed = false;
          choosePage();
        }),
        onPointerDown: (event) => setState(() {
          pressed = true;
        }),
        child: MainContainer(
          pressable: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: (pressed) ? null : Styles.linearGradients[index],
              borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        text,
                        style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
