import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_details_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var circlesIterable = task.tags.map((e) {
    //   return Container(
    //       width: 15,
    //       height: 15,
    //       margin: EdgeInsets.only(top: 10, left: 5, right: 5),
    //       decoration: BoxDecoration(
    //         color: Utils.tagColor(
    //             isWhite: false, isDetail: false, drpv: tagToNameMap[e]),
    //         shape: BoxShape.circle,
    //       ));
    // });
    //List<Widget> circles = circlesIterable.toList();

    Utils.statusBarColor();
    void openTaskDetails() {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return TaskDetailsScreen(
          task: task,
        );
      }));
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: openTaskDetails,
              child: Container(
                padding: EdgeInsets.all(3),
                color: taskColorDark,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        task.name,
                        maxLines: 1,
                        style: headerTextWithOverflow,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: clearColor,
                      width: 200,
                      height: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        task.text,
                          maxLines: 5,
                          style: standartTextWithOverflow,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        task.taskCreateTime,

                          style: smallItalicText
                      ),
                    ),
                    Visibility(
                        visible: task.isPushed ? false : true,
                        child: Icon(Icons.access_time)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
