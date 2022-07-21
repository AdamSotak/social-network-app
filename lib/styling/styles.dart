import 'package:flutter/material.dart';

class Styles {
  // Values
  static const double buttonSplashRadius = 20.0;
  static const double gradientSelectorStartWidth = 2.0;
  static const double gradientSelectorEndWidth = 5.0;
  static const double mainButtonBorderRadius = 100.0;
  static const double maxTextFieldWidth = 500.0;
  static const int calendarViewCarouselInitialPage = 1500;
  static const String defaultPhotoURLValue = "assets/images/profile_image.jpg";
  static const String defaultPhotoURL = '/assets/default_photo.png';
  static const Duration animationDuration = Duration(milliseconds: 200);

  // Colors
  static const Color accentColor = Color.fromARGB(255, 32, 174, 250);
  static const Color splashColor = Color.fromARGB(110, 255, 255, 255);

  // BoxShadows
  static final BoxShadow boxShadow =
      BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 7, offset: const Offset(0.0, 3.0));

  // Functions
  static bool checkIfStringEmpty(String string) {
    return string.isEmpty || RegExp(r"/^\s+$/").hasMatch(string);
  }
}
