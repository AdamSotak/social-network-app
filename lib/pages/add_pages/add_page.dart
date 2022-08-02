import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/enums/post_type.dart';
import 'package:social_network/pages/add_pages/add_loop_page.dart';
import 'package:social_network/pages/add_pages/add_post_page.dart';
import 'package:social_network/pages/add_pages/add_song_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

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
          const AddWidget(
            text: "Loop",
            nextPage: AddLoopPage(),
            index: 0,
          ),
          const AddWidget(
            text: "Song",
            nextPage: AddSongPage(),
            index: 1,
          ),
          const AddWidget(
            text: "Text",
            nextPage: AddPostPage(postType: PostType.text),
            index: 2,
          ),
          const AddWidget(
            text: "Picture",
            nextPage: AddPostPage(postType: PostType.image),
            index: 3,
          ),
          const AddWidget(
            text: "Video",
            nextPage: AddPostPage(postType: PostType.video),
            index: 4,
          ),
        ],
      ),
    );
  }
}

class AddWidget extends StatefulWidget {
  const AddWidget({
    Key? key,
    required this.text,
    this.subtext = "",
    required this.index,
    required this.nextPage,
  }) : super(key: key);

  final String text;
  final String subtext;
  final int index;
  final Widget nextPage;

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var subtext = widget.subtext;
    var index = widget.index;
    var nextPage = widget.nextPage;

    void openPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => nextPage));
    }

    return Flexible(
      child: Listener(
        onPointerUp: (event) => setState(() {
          pressed = false;
          openPage();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),
                      ),
                      (subtext != "")
                          ? Text(
                              subtext,
                              style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white),
                            )
                          : Container(),
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
