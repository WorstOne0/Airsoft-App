// Flutter Package
import 'package:flutter/material.dart';

// This code was only copied from the last Flutter Project
extension StringExtension on String {
  Color? toColor() {
    String hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  String numericOnly() => replaceAll(RegExp('[^0-9]'), "");

  String alphaNumericOnly() => replaceAll(RegExp('[^A-Za-z0-9]'), "");

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  // My Code
  // To correct the TextOverflow.ellipsis
  String tight() {
    return Characters(this)
        .replaceAll(Characters(' '), Characters('\u{000A0}'))
        .replaceAll(Characters('-'), Characters('\u{2011}'))
        .toString();
  }
}
