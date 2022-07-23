import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Styles {
  // Values
  static const double buttonSplashRadius = 20.0;
  static const double gradientSelectorStartWidth = 2.0;
  static const double gradientSelectorEndWidth = 5.0;
  static const double mainButtonBorderRadius = 100.0;
  static const double maxTextFieldWidth = 500.0;
  static const double mainBorderRadius = 20.0;
  static const int calendarViewCarouselInitialPage = 1500;
  static const String defaultPhotoURLValue = "development_assets/images/profile_image.jpg";
  static const String defaultPhotoURL = '/assets/default_photo.png';
  static const Duration animationDuration = Duration(milliseconds: 200);

  // Colors
  static const Color accentColor = Color.fromARGB(255, 32, 174, 250);
  static const Color splashColor = Color.fromARGB(110, 255, 255, 255);
  static const Color listTileBackgroundColor = Color.fromARGB(110, 255, 255, 255);

  // Color Gradients
  static const List<LinearGradient> linearGradients = [
    LinearGradient(
        colors: [Color.fromARGB(255, 242, 112, 155), Color.fromARGB(255, 255, 148, 114)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
    LinearGradient(
        colors: [Color.fromARGB(255, 161, 196, 253), Color.fromARGB(255, 194, 233, 251)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
    LinearGradient(
        colors: [Color.fromARGB(255, 247, 148, 165), Color.fromARGB(255, 253, 213, 189)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
    LinearGradient(
        colors: [Color.fromARGB(255, 236, 172, 245), Color.fromARGB(255, 33, 213, 253)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
    LinearGradient(
        colors: [Color.fromARGB(255, 161, 140, 209), Color.fromARGB(255, 251, 194, 235)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
    LinearGradient(
        colors: [Color.fromARGB(255, 251, 194, 235), Color.fromARGB(255, 166, 192, 238)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter),
  ];

  // BoxShadows
  static final BoxShadow boxShadow =
      BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 7, offset: const Offset(0.0, 3.0));

  // Functions
  static bool checkIfStringEmpty(String string) {
    return string.isEmpty || RegExp(r"/^\s+$/").hasMatch(string);
  }

  // Returns UUID
  static String getUUID() {
    return const Uuid().v4();
  }

  // Returns a formatted date string
  static String getFormattedDateString(DateTime dateTime) {
    return DateFormat.yMMMMEEEEd().format(dateTime);
  }

  // Returns a formatted number string
  static String getFormattedNumberString(int number) {
    return NumberFormat.decimalPattern().format(number);
  }

  // Returns a random LinearGradient
  static LinearGradient getRandomLinearGradient() {
    var random = Random();
    return linearGradients[random.nextInt(linearGradients.length)];
  }
}
