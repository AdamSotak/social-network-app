import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/pages/posts/add_post_page.dart';
import 'package:social_network/pages/create_account_page.dart';
import 'package:social_network/pages/main_page.dart';
import 'package:social_network/pages/login_page.dart';
import 'package:social_network/styling/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(titleTextStyle: GoogleFonts.raleway(color: Colors.black, fontSize: 25.0)),
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey.withOpacity(0.3),
            elevation: 0.0,
            unselectedLabelStyle: GoogleFonts.raleway(color: Colors.white, fontSize: 12.0),
            selectedLabelStyle: GoogleFonts.raleway(color: Colors.black),
            selectedItemColor: Styles.accentColor),
        cardTheme: const CardTheme(elevation: 10.0, color: Colors.white),
        radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5))),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Styles.accentColor.withOpacity(0.7),
            selectionHandleColor: Styles.accentColor),
        checkboxTheme: CheckboxThemeData(fillColor: MaterialStateProperty.all(Styles.accentColor)),
        dividerTheme: DividerThemeData(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        dialogTheme: DialogTheme(
            backgroundColor: const Color.fromARGB(255, 170, 170, 170),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
            contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 200, 200, 200)))),
        textTheme: TextTheme(
          headline1: GoogleFonts.raleway(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
          headline2: GoogleFonts.raleway(color: Colors.black, fontSize: 15.0),
          headline3: GoogleFonts.raleway(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          headline4: GoogleFonts.raleway(color: Colors.black, fontSize: 20.0),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(titleTextStyle: GoogleFonts.raleway(color: Colors.white, fontSize: 25.0)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 47, 51),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color.fromARGB(255, 27, 25, 27)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color.fromARGB(255, 30, 30, 30),
            elevation: 100.0,
            unselectedLabelStyle: GoogleFonts.raleway(color: Colors.white, fontSize: 12.0),
            selectedLabelStyle: GoogleFonts.raleway(color: Colors.white),
            unselectedItemColor: Colors.white,
            selectedItemColor: Styles.accentColor),
        cardTheme: const CardTheme(elevation: 10.0, color: Styles.listTileBackgroundColor),
        radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5))),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Styles.accentColor.withOpacity(0.7),
            selectionHandleColor: Styles.accentColor),
        checkboxTheme: CheckboxThemeData(fillColor: MaterialStateProperty.all(Styles.accentColor)),
        dividerTheme: const DividerThemeData(color: Colors.white, thickness: 0.5),
        listTileTheme: const ListTileThemeData(textColor: Colors.white),
        dialogTheme: DialogTheme(
            backgroundColor: const Color.fromARGB(255, 170, 170, 170),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
            contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 200, 200, 200)))),
        textTheme: TextTheme(
          headline1: GoogleFonts.raleway(color: Colors.white, fontSize: 20.0, height: 1.2),
          headline2: GoogleFonts.raleway(color: Colors.white, fontSize: 15.0),
          headline3: GoogleFonts.raleway(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          headline4: GoogleFonts.raleway(color: Colors.white, fontSize: 20.0),
        ),
      ),
      routes: {
        '/': (context) => StreamBuilder(
              stream: Auth().user,
              builder: ((context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.uid == null) {
                    return const LoginPage();
                  } else {
                    return const MainPage();
                  }
                } else {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
            ),
        '/login': (context) => const LoginPage(),
        '/createAccount': (context) => const CreateAccountPage(),
        '/addpost': (context) => const AddPostPage()
      },
      initialRoute: '/',
    );
  }
}
