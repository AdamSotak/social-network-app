import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchTextEditingController = TextEditingController();
  List<UserData> userData = [];

  @override
  Widget build(BuildContext context) {
    void search() {
      setState(() {});
    }

    void onSearchResultPressed(UserData searchUserData) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => ProfilePage(
            userId: searchUserData.id,
            backButton: true,
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 10.0),
        child: Column(
          children: [
            Row(
              children: [
                const MainBackButton(),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: MainTextField(
                    controller: searchTextEditingController,
                    hintText: "Search...",
                    onEditingComplete: search,
                    autofocus: true,
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: UserDataDatabase().searchUserData(searchQuery: searchTextEditingController.text),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Error and loading checking
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
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

                userData.clear();

                userData.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  var userData = UserData.fromDocumentSnapshot(documentSnapshot);
                  return userData;
                }));

                if (userData.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: NoDataTile(
                      text: "Ooops",
                      subtext: "No results match your search",
                    ),
                  );
                }

                return ListView.builder(
                  clipBehavior: Clip.none,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: userData.length,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemBuilder: (context, index) {
                    var data = userData[index];
                    return MainContainer(
                      pressable: true,
                      onPressed: () {
                        onSearchResultPressed(data);
                      },
                      child: UserDataWidget(userData: data),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}