import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static int calculatePercentage(int available, int total) {
    return ((available / total) * 100).round();
  }

  static String formatNumber(double amount) {
    NumberFormat numberFormat;
    if (amount >= 1000000) {
      numberFormat = NumberFormat.compact();
    } else {
      numberFormat = NumberFormat();
    }
    return numberFormat.format(amount);
  }

  static String preferredDateFormat(DateTime dateTime,
      {bool includeTime = false}) {
    return includeTime
        ? DateFormat.yMMMEd('en_US').add_jm().format(dateTime)
        : DateFormat.yMMMEd('en_US').format(dateTime);
  }

  static bool isMorning() {
    if (TimeOfDay.now().period == DayPeriod.am) {
      return true;
    } else {
      return false;
    }
  }

  static String customAvatar(String text) {
    final List<String> splittedText = text.split(' ');
    if (splittedText.length > 1) {
      return splittedText[0][0].toUpperCase() +
          splittedText[1][0].toUpperCase();
    } else {
      return splittedText[0][0].toUpperCase() +
          splittedText[0][1].toUpperCase();
    }
  }

  static void showSnackBar(
    GlobalKey<ScaffoldState> scaffoldKey,
    String message, {
    Color color,
    Color textColor,
    Duration duration,
    SnackBarBehavior behavior,
  }) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: behavior ?? SnackBarBehavior.fixed,
      duration: duration ?? const Duration(seconds: 8),
      content: textColor == null
          ? Text(message)
          : Text(
              message,
              style: TextStyle(color: textColor),
            ),
      backgroundColor: color,
    ));
  }

  static void showSuccessSnackBar(
    GlobalKey<ScaffoldState> scaffoldKey,
    String message, {
    Duration duration,
    SnackBarBehavior behavior,
  }) {
    return showSnackBar(
      scaffoldKey,
      message,
      duration: duration,
      behavior: behavior,
      color: const Color(0xFFd4edda),
      textColor: const Color(0xFF155724),
    );
  }

  static void showInfoSnackBar(
    GlobalKey<ScaffoldState> scaffoldKey,
    String message, {
    Duration duration,
    SnackBarBehavior behavior,
  }) {
    return showSnackBar(
      scaffoldKey,
      message,
      duration: duration,
      behavior: behavior,
      color: const Color(0xFFd1ecf1),
      textColor: const Color(0xFF0c5460),
    );
  }

  static void showErrorSnackBar(
    GlobalKey<ScaffoldState> scaffoldKey,
    String message, {
    Duration duration,
    SnackBarBehavior behavior,
  }) {
    return showSnackBar(
      scaffoldKey,
      message,
      duration: duration,
      behavior: behavior,
      color: const Color(0xFFf8dfda),
      textColor: const Color(0xFF721c24),
    );
  }

  static Uint8List base64ToImage(String base64) {
    final base = base64.substring(base64.indexOf(',') + 1, base64.length);
    final bytes = base64Decode(base);
    return bytes;
  }

  static TimeOfDay formatVendorTime(String time) {
    final timeSplit = time.split(':');
    final timeOfDay = TimeOfDay(
        hour: int.parse(timeSplit[0]), minute: int.parse(timeSplit[1]));
    return timeOfDay;
  }

  static String addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  static String capitalizeFirstLetter(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  static int getColorFromHex(String hexColor) {
    String _hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (_hexColor.length == 6) {
      _hexColor = "FF$_hexColor";
    }
    return int.parse(_hexColor, radix: 16);
  }

  static String formatVerseText(String verse) {
    String formatText = verse
        .replaceAll(RegExp('<[^Ja-zA-Z]*/*>', caseSensitive: false), '')
        .replaceAll(RegExp('</[^Ja-zA-Z]*>', caseSensitive: false), '');
    formatText = formatText.replaceAll('J>', 'mark>');
    formatText = formatText.replaceAll(
        RegExp('[^a-zA-Z<> ]*', caseSensitive: false), '');
    formatText = formatText.replaceAll(
        RegExp('<f>[^a-z]*<f>', caseSensitive: false), '');
    formatText =
        formatText.replaceAll(RegExp('<pb>', caseSensitive: false), '');
    return '<div> $formatText </div>';
  }
}

class SharedPref {
  Future<bool> setBool(String key, {@required bool value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
