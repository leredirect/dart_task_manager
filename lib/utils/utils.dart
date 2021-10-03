import 'dart:ui';

import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';

import '../constants.dart';

class Utils {
  static List<S2Choice<int>> s2TagsList() {
    List<S2Choice<int>> s2Options = [];
    List<Tags> tags = new List.from(Tags.values);

    tags.removeWhere(
        (element) => (element == Tags.EXPIRED) | (element == Tags.CLEAR));
    for (int i = 0; i < tags.length; i++) {
      s2Options.add(S2Choice<int>(value: i, title: tagToNameMap[tags[i]]));
    }
    return s2Options;
  }

  static List<S2Choice<int>> s2PriorityList() {
    List<S2Choice<int>> s2priority = [];
    List<Priorities> priority = new List.from(Priorities.values);
    for (int i = 0; i < priority.length; i++) {
      s2priority
          .add(S2Choice<int>(value: i, title: priorityToNameMap[priority[i]]));
    }
    return s2priority;
  }

  static SystemUiOverlayStyle statusBarColor() {
    return SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light);
  }

  static String tagsDisplay(List tags) {
    String result = "";
    for (int i = 0; i < tags.length; i++) {
      if (tags.length - 1 == i) {
        result = result + tagToNameMap[tags[i]];
      } else {
        result = result + tagToNameMap[tags[i]] + ", ";
      }
    }
    return result;
  }
}

void snackBarNotification(context, String text,
    {int duration, Color backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    width: MediaQuery.of(context).size.width/2.2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    backgroundColor: backgroundColor == null ? snackBarColor.withOpacity(0.9) : backgroundColor.withOpacity(0.9),
    duration: Duration(seconds: duration == null ? 3 : duration),
    content: Text(text, style: standartTextWithoutOverflow, textAlign: TextAlign.center,),
  ));
}



final nameToPriorityMap = {
  "высокий": Priorities.HIGH,
  "средний": Priorities.MEDIUM,
  "низкий": Priorities.LOW,
};

final priorityToNameMap = {
  Priorities.HIGH: "высокий",
  Priorities.MEDIUM: "средний",
  Priorities.LOW: "низкий",
};

final nameToTagMap = {
  "flutter": Tags.FLUTTER,
  "dart": Tags.DART,
  "алгоритмы": Tags.ALGORITHMS,
  "нет фильтра": Tags.CLEAR,
  "истекшие": Tags.EXPIRED,
};

final tagToNameMap = {
  Tags.FLUTTER: "flutter",
  Tags.DART: "dart",
  Tags.ALGORITHMS: "алгоритмы",
  Tags.CLEAR: "нет фильтра",
  Tags.EXPIRED: "истекшие",
};