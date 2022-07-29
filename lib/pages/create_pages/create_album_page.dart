import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/music_widgets/album_listview_tile.dart';
import 'package:social_network/widgets/music_widgets/playlists/playlist_song_listview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';

class CreateAlbumPage extends StatefulWidget {
  const CreateAlbumPage({Key? key}) : super(key: key);

  @override
  State<CreateAlbumPage> createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController albumNameTextEditingController = TextEditingController();
  String albumImageButton = "Add Album Artwork";
  List<Song> songs = [];
  List<Song> albumSongs = [];

  Album album = Album(
    id: "preview",
    userId: Auth().getUserId(),
    artworkURL: "",
    name: "",
    songs: [],
    created: DateTime.now(),
  );

  @override
  void dispose() {
    albumNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void createAlbum() {
      if (Styles.checkIfStringEmpty(albumNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the Album's name");
        return;
      }

      if (albumSongs.length < Variables.minimumAlbumSongsLength) {
        DialogManager().displaySnackBar(context: context, text: "Please choose at least 2 songs");
        return;
      }

      if (album.artworkURL == "") {
        DialogManager().displaySnackBar(context: context, text: "Please choose Album artwork");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      album.id = Auth.getUUID();
      album.name = albumNameTextEditingController.text;
      album.songs = albumSongs;
      album.created = DateTime.now();

      AlbumsDatabase().addAlbum(album).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    void onSongChosen(Song song) {
      if (albumSongs.contains(song)) {
        albumSongs.remove(song);
      } else {
        albumSongs.add(song);
      }
    }

    void onAlbumNameChanged(String value) {
      setState(() {
        album.name = value;
      });
    }

    void addAlbumArtwork() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;
      var decodedImage = await decodeImageFromList(await image.readAsBytes());
      if (decodedImage.width - decodedImage.height > 5 || decodedImage.width - decodedImage.height < 0) {
        DialogManager().displaySnackBar(context: context, text: "Please use an image with equal width and height");
        return;
      }

      setState(() {
        albumImageButton = "Change Album Artwork";
        album.artworkURL = image.path;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Create Album",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: createAlbum,
              ),
              const SizedBox(
                height: 50.0,
              ),
              AlbumListViewTile(album: album),
              MainTextField(
                controller: albumNameTextEditingController,
                hintText: "Album Name",
                onChanged: onAlbumNameChanged,
              ),
              MainButton(text: albumImageButton, onPressed: addAlbumArtwork),
              StreamBuilder<QuerySnapshot>(
                stream: SongsDatabase().getSongStream(userId: Auth().getUserId()),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Error and loading checking
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text("Something went wrong"),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  songs.clear();

                  songs.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    var post = Song.fromDocumentSnapshot(documentSnapshot);
                    return post;
                  }));

                  if (songs.isEmpty) {
                    return Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: NoDataTile(
                            text: "No Songs Yet",
                            subtext: "Please add some songs first",
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        clipBehavior: Clip.none,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: songs.length,
                        padding: const EdgeInsets.only(top: 20.0),
                        itemBuilder: (context, index) {
                          var song = songs[index];
                          return PlaylistSongListViewTile(
                            song: song,
                            chooseSong: true,
                            onSongChosen: onSongChosen,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
