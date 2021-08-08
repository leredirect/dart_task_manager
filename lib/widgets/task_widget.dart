import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_details_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils.statusBarColor();
    void openTaskDetails() {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return TaskDetailsScreen(
            task: task,
          );
        },
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
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
          color: Utils.tagColor(isWhite:false, isDetail: true, drpv: null, tag: task.tag),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.black,
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
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  task.taskCreateTime,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
