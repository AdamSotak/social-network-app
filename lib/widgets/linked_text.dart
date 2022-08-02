import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkedText extends StatelessWidget {
  const LinkedText(this.text, {Key? key, this.style = const TextStyle()}) : super(key: key);

  final String text;
  final TextStyle? style;

  String cleanText(String textValue) {
    textValue = textValue.replaceAllMapped(RegExp(r'\w#+'), (match) => "${match[0]?.split('').join(" ")}");
    textValue = textValue.replaceAllMapped(RegExp(r'\w@+'), (match) => "${match[0]?.split('').join(" ")}");
    return textValue;
  }

  List<String> getAllHashtags(String textValue) {
    List<String> hashtags = [];

    RegExp(r'\#[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((hashtag) {
      if (hashtag.group(0) != null) {
        hashtags.add(hashtag.group(0).toString());
      }
    });

    return hashtags;
  }

  List<String> getAllMentions(String textValue) {
    List<String> mentions = [];

    RegExp(r'\@[a-zA-Z0-9]+\b()').allMatches(textValue).forEach((mention) {
      if (mention.group(0) != null) {
        mentions.add(mention.group(0).toString());
      }
    });

    return mentions;
  }

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
    void openHashtag(String hashtag) {}

    void openProfile(String username) {}

    void openUrl(String url) {}

    String textValue = cleanText(text);

    List<String> hashtags = getAllHashtags(textValue);
    List<String> mentions = getAllMentions(textValue);
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

    return RichText(text: TextSpan(children: textSpans));
  }
}
