import 'package:flutter/material.dart';
import 'package:social_network/pages/add_pages/add_page.dart';
import 'package:social_network/pages/create_pages/create_album_page.dart';
import 'package:social_network/pages/create_pages/create_song_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            child: Text(
              "Create",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          const AddWidget(
            text: "Song",
            subtext: "Digital Audio Workstation to create your own tracks",
            nextPage: CreateSongPage(),
          ),
          const AddWidget(
            text: "Album",
            subtext: "Create Album with songs you created",
            nextPage: CreateAlbumPage(),
          ),
        ],
      ),
    );
  }
}
