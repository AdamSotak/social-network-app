import 'package:flutter/material.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/widgets/main_app_bar.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;
    return Scaffold(
      appBar: MainAppBar(title: playlist.name),
    );
  }
}
