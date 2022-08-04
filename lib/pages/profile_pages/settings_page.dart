import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/main.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/account_pages/change_email_page.dart';
import 'package:social_network/pages/account_pages/change_password_page.dart';
import 'package:social_network/pages/account_pages/delete_account_page.dart';
import 'package:social_network/storage/app_theme/theme_mode_change_notifier.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode themeMode = ThemeModeChangeNotifier.themeMode;
  late String themeModeString = Styles.getThemeModeString(themeMode);

  @override
  Widget build(BuildContext context) {
    void settingsDone() {}

    void openChangeEmailPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const ChangeEmailPage()));
    }

    void openChangePasswordPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const ChangePasswordPage()));
    }

    void setThemeMode(ThemeMode newThemeMode) {
      final provider = Provider.of<ThemeModeChangeNotifier>(context, listen: false);
      provider.setTheme(newThemeMode);
      setState(() {
        themeMode = newThemeMode;
        themeModeString = Styles.getThemeModeString(themeMode);
      });
      SystemChrome.setSystemUIOverlayStyle(
          ThemeModeChangeNotifier().darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
      Navigator.pop(context);
    }

    // Display ModalBottomSheet for choosing AppTheme
    void openChangeAppThemeModalBottomSheet() {
      DialogManager().displayModalBottomSheet(context: context, title: "App Theme", options: [
        ListTile(
          onTap: () {
            setThemeMode(ThemeMode.system);
          },
          leading: Icon(
            Icons.smartphone,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            "Device default",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        ListTile(
          onTap: () {
            setThemeMode(ThemeMode.dark);
          },
          leading: Icon(
            Icons.dark_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            "Dark",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        ListTile(
          onTap: () {
            setThemeMode(ThemeMode.light);
          },
          leading: Icon(
            Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            "Light",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
          },
          leading: Icon(
            Icons.close,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            "Close",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ]);
    }

    void logout() {
      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Confirm Logout",
        description: "Please confirm logout",
        onConfirmation: () {
          Auth().logout().then((value) {
            Navigator.pushAndRemoveUntil(
                context, CupertinoPageRoute(builder: (builder) => const App()), (route) => false);
          });
        },
        onCancellation: () {
          return;
        },
      );
    }

    void openDeleteAccountPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const DeleteAccountPage()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Settings",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: settingsDone,
              ),
              ListTile(
                title: Text(
                  "Change Email",
                  style: Theme.of(context).textTheme.headline3,
                ),
                onTap: openChangeEmailPage,
              ),
              ListTile(
                title: Text(
                  "Change Password",
                  style: Theme.of(context).textTheme.headline3,
                ),
                onTap: openChangePasswordPage,
              ),
              ListTile(
                title: Text(
                  "Change App Theme",
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: Text(
                  themeModeString,
                  style: Theme.of(context).textTheme.headline2,
                ),
                onTap: openChangeAppThemeModalBottomSheet,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListTile(
                title: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: Text(
                  "You will be logged out of the app",
                  style: Theme.of(context).textTheme.headline2,
                ),
                onTap: logout,
              ),
              const SizedBox(
                height: 50.0,
              ),
              ListTile(
                title: Text(
                  "Delete Account",
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.pinkAccent),
                ),
                subtitle: Text(
                  "The account and data will be erased",
                  style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.pinkAccent),
                ),
                onTap: openDeleteAccountPage,
              )
            ],
          ),
        ),
      ),
    );
  }
}
