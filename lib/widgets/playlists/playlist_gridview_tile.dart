import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/pages/playlists/playlist_page.dart';
import 'package:social_network/styling/styles.dart';

class PlaylistGridViewTile extends StatefulWidget {
  const PlaylistGridViewTile({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  State<PlaylistGridViewTile> createState() => _PlaylistGridViewTileState();
}

class _PlaylistGridViewTileState extends State<PlaylistGridViewTile> {
  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;

    void openPlaylistPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => PlaylistPage(
            playlist: playlist,
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
      ),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          gradient: Styles.getRandomLinearGradient(),
          borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
        ),
        margin: const EdgeInsets.all(5.0),
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
                    playlist.name,
                    style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 25.0),
                  ),
                  (playlist.songs.length != 1)
                      ? Text(
                          "${Styles.getFormattedNumberString(playlist.songs.length)} Songs",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          "${Styles.getFormattedNumberString(playlist.songs.length)} Song",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3.0),
                    borderRadius: BorderRadius.circular(Styles.mainButtonBorderRadius),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Styles.mainButtonBorderRadius),
                      onTap: openPlaylistPage,
                      splashColor: Styles.splashColor,
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
