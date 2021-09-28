import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_details_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../constants.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Color color;

  const TaskWidget({Key key, this.task, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
                color: this.color,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Visibility(
                        visible: task.isPushed ? false : true,
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "не загружено..",
                              style: smallItalicText,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                        style: standartText,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "дедлайн: ${DateFormat('dd-MM-yyyy в kk:mm').format(task.taskCreateTime).toString()}",
                                  style: smallItalicText),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
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
