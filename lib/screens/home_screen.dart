import 'package:dart_task_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_event.dart';
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
import 'package:enum_to_string/enum_to_string.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = tagToNameMap[Tags.DART];

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
          Container(
            margin: EdgeInsets.only(right: 10),
            child: DropdownButton<String>(
              style: TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: primaryColorDark,
              value: dropdownValue,
              isExpanded: false,
              icon: Icon(Icons.filter_alt, color: Colors.white,),
              iconSize: 24,
              underline: Container(
                height: 2,
                color: secondaryColorLight,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  final result = nameToTagMap[dropdownValue];
                  if (result == Tags.CLEAR){
                    context.bloc<FilterBloc>().add(ClearFilter(result));
                  }
                  else {
                    context.bloc<FilterBloc>().add(FilterChecker(result));
                  }
                });
              },
              items: nameToTagMap.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FilterBloc, Tags>(
        builder: (context, filtState) {
          print (filtState);
          return BlocBuilder<TaskListBloc, List<Task>>(
            builder: (context, state) {
              if (filtState != null) {
                List<Task> filtredState = state.where((element) =>
                element.tag == filtState).toList();
                return TaskListWidget(taskList: filtredState);
              }
              else {
                return TaskListWidget(taskList: state);
              }
            },
          );
        }
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
