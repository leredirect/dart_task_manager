import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/create_new_task_screen.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text("TaskManager"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: BlocBuilder<TaskListBloc, List<Task>>(
        builder: (context, state) {
          return TaskListWidget(taskList: state);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: createTask,
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
