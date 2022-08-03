import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/hashtags_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/pages/trending_pages/trending_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkedTextTools {
  static String cleanText(String textValue) {
    textValue = textValue.replaceAllMapped(RegExp(r'\w#+'), (match) => "${match[0]?.split('').join(" ")}");
    textValue = textValue.replaceAllMapped(RegExp(r'\w@+'), (match) => "${match[0]?.split('').join(" ")}");
    return textValue;
  }

  static List<String> getAllHashtags(String textValue) {
    List<String> hashtags = [];

    RegExp(r'\#[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((hashtag) {
      if (hashtag.group(0) != null) {
        hashtags.add(hashtag.group(0).toString());
      }
    });

    return hashtags;
  }

  static List<String> getAllMentions(String textValue) {
    List<String> mentions = [];

    RegExp(r'\@[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((mention) {
      if (mention.group(0) != null) {
        mentions.add(mention.group(0).toString());
      }
    });

    return mentions;
  }
}

class LinkedText extends StatelessWidget {
  const LinkedText(this.text, {Key? key, this.style = const TextStyle(), this.textAlign = TextAlign.left})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  List<String> getAllUrls(String textValue) {
    List<String> urls = [];

    RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)')
        .allMatches(textValue)
        .forEach((url) {
      if (url.group(0) != null) {
        urls.add(url.group(0).toString());
      }
    });

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    void openHashtag(String hashtagName) async {
      try {
        await HashtagsDatabase().getHashtag(hashtagName: hashtagName).then((hashtag) {
          Navigator.push(context, CupertinoPageRoute(builder: (builder) => TrendingPage(hashtag: hashtag)));
        });
      } catch (_) {
        DialogManager()
            .displayInformationDialog(context: context, title: "Ooops...", description: "Hashtag does not exist");
      }
    }

    void openProfile(String username) async {
      username = username.replaceFirst('@', '');
      try {
        await UserDataDatabase().getUserDataByUsername(username: username).then((userData) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (builder) => ProfilePage(
                userId: userData.id,
                backButton: true,
              ),
            ),
          );
        });
      } catch (_) {
        DialogManager()
            .displayInformationDialog(context: context, title: "Ooops...", description: "User does not exist");
      }
    }

    void openUrl(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    String textValue = LinkedTextTools.cleanText(text);

    List<String> hashtags = LinkedTextTools.getAllHashtags(textValue);
    List<String> mentions = LinkedTextTools.getAllMentions(textValue);
    List<String> urls = getAllUrls(textValue);

    List<TextSpan> textSpans = [];

    textValue.split(' ').forEach((value) {
      if (hashtags.contains(value)) {
        textSpans.add(
          TextSpan(
            text: '$value ',
            style: style!.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                openHashtag(value);
              },
          ),
        );
      } else if (mentions.contains(value)) {
        textSpans.add(TextSpan(
          text: '$value ',
          style: style!.copyWith(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              openProfile(value);
            },
        ));
      } else if (urls.contains(value)) {
        textSpans.add(TextSpan(
          text: '$value ',
          style: style!.copyWith(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              openUrl(value);
            },
        ));
      } else {
        textSpans.add(TextSpan(text: '$value ', style: style));
      }
    });

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: textAlign,
    );
  }
}
