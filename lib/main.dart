import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/pages/create_account_page.dart';
import 'package:social_network/pages/home_page.dart';
import 'package:social_network/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            headline1: GoogleFonts.dmSans(color: Colors.black, fontSize: 50.0),
            headline2: const TextStyle(color: Colors.black, fontSize: 15.0)),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.grey,
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
                    return const HomePage();
                  }
                } else {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
            ),
        '/login': (context) => const LoginPage(),
        '/createAccount': (context) => const CreateAccountPage()
      },
      initialRoute: '/',
    );
  }
}
