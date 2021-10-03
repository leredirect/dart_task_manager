import 'dart:ui';

import 'package:flutter/material.dart';

const backgroundColor = Color(0xff353E46);
const clearColor = Color(0xffE4DBDB);
const snackBarColor = Color(0xff3C4852);
const taskColorDark = Color(0xffFF65A3);

const MaterialColor stickyPrimary =
    MaterialColor(_stickyPrimaryPrimaryValue, <int, Color>{
  50: Color(0xFFFFEDF4),
  100: Color(0xFFFFD1E3),
  200: Color(0xFFFFB2D1),
  300: Color(0xFFFF93BF),
  400: Color(0xFFFF7CB1),
  500: Color(_stickyPrimaryPrimaryValue),
  600: Color(0xFFFF5D9B),
  700: Color(0xFFFF5391),
  800: Color(0xFFFF4988),
  900: Color(0xFFFF3777),
});
const int _stickyPrimaryPrimaryValue = 0xFFFF65A3;

const MaterialColor stickyPrimaryAccent =
    MaterialColor(_stickyPrimaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_stickyPrimaryAccentValue),
  400: Color(0xFFFFE1EA),
  700: Color(0xFFFFC8D8),
});
const int _stickyPrimaryAccentValue = 0xFFFFFFFF;

const TextStyle standartText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 13,
    letterSpacing: 2,
    color: Colors.white);

const TextStyle smallText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 9,
    letterSpacing: 2,
    color: Colors.white);

const TextStyle headerText =
    TextStyle(fontSize: 17, letterSpacing: 2, color: Colors.white);

const TextStyle standartTextWithoutOverflow =
    TextStyle(fontSize: 13, letterSpacing: 2, color: Colors.white);
const TextStyle headerTextWithOverflow = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 17,
    letterSpacing: 2,
    color: Colors.white);

const TextStyle bigText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 21,
    letterSpacing: 2,
    color: Colors.white);

const TextStyle standartGreyText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 13,
    letterSpacing: 2,
    color: Colors.grey);
const TextStyle smallLetterSpacingStandartText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 13,
    letterSpacing: 1,
    color: Colors.white);

const TextStyle smallItalicText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontStyle: FontStyle.italic,
    fontSize: 9,
    letterSpacing: 1,
    color: Colors.white);

const TextStyle smallLetterSpacingStandartGreyText = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 13,
    letterSpacing: 0,
    color: Colors.grey);
