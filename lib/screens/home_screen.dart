import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/create_new_task_screen.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void createTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return CreateNewTaskScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("TaskManager"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<TaskListBloc, List<Task>>(
        builder: (context, state) {
          return TaskListWidget(taskList: state);
        },
      ),
      backgroundColor: primaryColorDark,
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: createTask,
        backgroundColor: secondaryColorLight,
      ),
    );
  }

  @override
  void initState() {
    Hive.openBox('taskList').then((listBox) {
      if (listBox.get('task') == null) {
        List<Task> taskList = [];
        listBox.put('task', taskList);
      } else {
        List<Task> hiveTasks = listBox.get('task').cast<Task>();
        context.bloc<TaskListBloc>().add(HiveChecker(hiveTasks));
      }
      listBox.close();
    });
  }
}
