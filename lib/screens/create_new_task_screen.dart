import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();

  void addTask(String tag) {
    String taskName = _nameController.text;
    String taskText = _textController.text;
    Task task = Task(taskName, taskText, tag);
    context.bloc<TaskListBloc>().add(AddTaskEvent(task));
    Navigator.of(context).pop();
  }

  String dropdownValue = "Dart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Новая задача"), backgroundColor: Colors.redAccent,),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Название задачи", contentPadding: EdgeInsets.only(left: 5)),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: "Условия задачи", contentPadding: EdgeInsets.only(left: 5), focusColor: Colors.redAccent),
          ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),

          child: DropdownButton<String>(
            value: dropdownValue,
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.redAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Dart', 'Flutter', 'Алгоритмы',]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),

        Spacer(),
          InkWell(
              onTap:() => addTask(dropdownValue),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12)
                ),
                width: 200,
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: EdgeInsets.only(bottom: 50),
                child: Center(child: Text("Подтвердить", style: TextStyle(color: Colors.white),)),
                // color: Colors.redAccent,
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
