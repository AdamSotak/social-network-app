import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<String> addWidgets = ["Loop", "Song", "Picture", "Video"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: Text(
                "Add...",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              clipBehavior: Clip.none,
              itemCount: addWidgets.length,
              itemBuilder: (context, index) {
                return AddWidget(
                  text: addWidgets[index],
                  index: index,
                );
              },
            ),
          ],
        ),
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
    return Listener(
      onPointerUp: (event) => setState(() {
        pressed = false;
      }),
      onPointerDown: (event) => setState(() {
        pressed = true;
      }),
      child: MainContainer(
        height: 140.0,
        pressable: true,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 140.0,
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
    );
  }
}
