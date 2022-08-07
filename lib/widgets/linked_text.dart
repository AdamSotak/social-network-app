import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/hashtags_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/pages/trending_pages/trending_page.dart';
import 'package:url_launcher/url_launcher.dart';

// Widget to match hashtags, user mentions and URLs in a String and render the text

class LinkedTextTools {
  // Clean the text
  static String cleanText(String textValue) {
    textValue = textValue.replaceAllMapped(RegExp(r'\w#+'), (match) => "${match[0]?.split('').join(" ")}");
    textValue = textValue.replaceAllMapped(RegExp(r'\w@+'), (match) => "${match[0]?.split('').join(" ")}");
    return textValue;
  }

  // Match String to a Regex to get all hashtags
  static List<String> getAllHashtags(String textValue) {
    List<String> hashtags = [];

    RegExp(r'\#[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((hashtag) {
      if (hashtag.group(0) != null) {
        hashtags.add(hashtag.group(0).toString());
      }
    });

    return hashtags;
  }

  // Match String to a Regex to get all user mentions
  static List<String> getAllMentions(String textValue) {
    List<String> mentions = [];

    RegExp(r'\@[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((mention) {
      if (mention.group(0) != null) {
        mentions.add(mention.group(0).toString());
      }
    });

    return mentions;
  }

  // Match String to a Regex to get all URLs
  static List<String> getAllUrls(String textValue) {
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
}

class LinkedText extends StatelessWidget {
  const LinkedText(this.text, {Key? key, this.style = const TextStyle(), this.textAlign = TextAlign.left})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;


  @override
  Widget build(BuildContext context) {
    // Check if the hashtag in the database and open TrendingPage for the hashtag
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

    // Check the user in the database and open ProfilePage for the user
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

    // Open the URL in a web browser
    void openUrl(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    String textValue = LinkedTextTools.cleanText(text);

    List<String> hashtags = LinkedTextTools.getAllHashtags(textValue);
    List<String> mentions = LinkedTextTools.getAllMentions(textValue);
    List<String> urls = LinkedTextTools.getAllUrls(textValue);

    List<TextSpan> textSpans = [];

    // Match the values to TextSpans and display them in RichText
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
