import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_event.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/repo.dart';
import 'package:dart_task_manager/screens/create_new_task_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = tagToNameMap[Tags.CLEAR];

  void createTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return CreateNewTaskScreen();
      },
    ));
  }

  bool isOnlineVar;

  @override
  Widget build(BuildContext context) {
    void isOnline() async {
      var internet = await (Connectivity().checkConnectivity());
      switch (internet) {
        case ConnectivityResult.wifi:
          setState(() {
            isOnlineVar = true;
          });
          break;
        case ConnectivityResult.mobile:
          setState(() {
            isOnlineVar = true;
          });
          break;
        case ConnectivityResult.none:
          setState(() {
            isOnlineVar = false;
          });
          break;
      }
    }

    isOnline();
    Utils.statusBarColor();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        backwardsCompatibility: false,
        backgroundColor: primaryColorLight,
        title: Text(
          "TaskManager",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: DropdownButton<String>(
              style: TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: primaryColorDark,
              value: dropdownValue,
              isExpanded: false,
              icon: Icon(
                Icons.filter_alt,
                color: Utils.tagColor(
                    isWhite: false, isDetail: false, drpv: dropdownValue),
              ),
              iconSize: 24,
              underline: Container(
                height: 2,
                color: Utils.tagColor(
                    isWhite: false, isDetail: false, drpv: dropdownValue),
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  final result = nameToTagMap[dropdownValue];
                  if (result == Tags.CLEAR) {
                    context.read<FilterBloc>().add(ClearFilter(result));
                  } else {
                    context.read<FilterBloc>().add(FilterChecker(result));
                  }
                });
              },
              items: nameToTagMap.keys
                  .map<DropdownMenuItem<String>>((String value) {
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
      body: BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
        return BlocBuilder<TaskListBloc, List<Task>>(
          builder: (context, state) {
            if (filtState != null) {
              List<Task> filtredState =
                  state.where((element) => element.tag == filtState).toList();
              return AnimationConfiguration.synchronized(
                //duration: const Duration(milliseconds: 5000),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                      child: TaskListWidget(taskList: filtredState)),
                ),
              );
            } else {
              return AnimationConfiguration.synchronized(
                //duration: const Duration(milliseconds: 5000),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child:
                      FadeInAnimation(child: TaskListWidget(taskList: state)),
                ),
              );
            }
          },
        );
      }),
      floatingActionButton: Visibility(
        visible: isOnlineVar,
        child: FloatingActionButton(
          child: Text(
            "+",
            style: TextStyle(color: primaryColor),
          ),
          onPressed: createTask,
          backgroundColor: Utils.tagColor(
              isWhite: false, isDetail: false, drpv: dropdownValue),
        ),
      ),
      backgroundColor: primaryColor,
    );
  }

  void snackBarDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(minutes: 10),
      content: Text('Отсутствует подключение к сети. Режим просмотра.'),
      action: SnackBarAction(
        label: 'Повторить',
        onPressed: () {
          var connectivityResult =
              Connectivity().checkConnectivity().then((value) {
            if (value == ConnectivityResult.none) {
              snackBarDisplay();
              print("here");
            } else {
              print("exit");
             setState(() {

             });
            }
          });
        },
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    var connectivityResult = Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        snackBarDisplay();
        print("none");
        Hive.openBox('taskList').then((listBox) {
          if (listBox.get('task') == null) {
            List<Task> taskList = [];
            listBox.put('task', taskList);
          } else {
            List<Task> hiveTasks = listBox.get('task').cast<Task>();
            context.read<TaskListBloc>().add(HiveChecker(hiveTasks));
          }
          listBox.close();
        });
      } else {
        List<Task> tasks = [];
        Stream<QuerySnapshot> collection = Repository().getStream();
        collection.first.then((value) {
          value.docs.forEach((element) {
            tasks.add(Task.fromJson(element.data()));
          });
          context.read<TaskListBloc>().add(HiveChecker(tasks));
        });
        print("connected");
      }
    });
  }
}
