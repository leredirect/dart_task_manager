import 'dart:ui';

import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Utils {
  static Color tagColor(bool isWhite, bool isDetail, [String drp, Tags tag]) {
    Tags drpEnum = nameToTagMap[drp];
    if (isWhite) {
      switch (drpEnum) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return primaryColorLight;
      }
    } else if (isDetail) {
      switch (tag) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return primaryColor;
      }
    } else {
      switch (drpEnum) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return clearColor;
      }
    }
  }

  static String timeHint(pickedDate, pickedTime) {
    if (pickedDate != null && pickedTime != null) {
      return "Выбранная дата: ${pickedDate.day}-${pickedDate.month}-${pickedDate.year}\nВыбранное время: ${pickedTime.hour}:${pickedTime.minute}";
    } else {
      return "Выберите время";
    }
  }
}
