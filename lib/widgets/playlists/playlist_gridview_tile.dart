import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/enums/music_player_type.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/pages/music_pages/music_player_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

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
    LinearGradient gradient = Styles.getRandomLinearGradient();

    void openMusicPlayerPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => MusicPlayerPage(
            playlist: playlist,
            musicPlayerType: MusicPlayerType.playlist,
          ),
        ),
      );
    }

    return MainContainer(
      margin: const EdgeInsets.all(5.0),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          gradient: gradient,
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
                child: MainIconButton(
                  width: 55.0,
                  height: 55.0,
                  margin: EdgeInsets.zero,
                  gradient: gradient,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: openMusicPlayerPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
