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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentFilter = tagToNameMap[Tags.CLEAR];

  void createTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return CreateNewTaskScreen();
      },
    ));
  }

  bool isOnlineVar;
  void myStream () {
    // StreamBuilder<QuerySnapshot>(
    //     stream: Repository().getStream(),
    //     builder: (context, snapshot) {
    //       print('here');
    //       List<Task> tasks = [];
    //       snapshot.data.docs.forEach((element) {
    //         tasks.add(Task.fromJson(element.data()));
    //       });
    //       context.read<TaskListBloc>().add(HiveChecker(tasks));
    //     });

    List<Task> tasks = [];
    Stream<QuerySnapshot> collection = Repository().getStream();
    collection.first.then((value) {
      value.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
      });
      context.read<TaskListBloc>().add(HiveChecker(tasks));
    });
    print("connected");
    snackBarDisplay();
  }

  @override
  Widget build(BuildContext context) {
    SpeedDialChild mySpeedDialChild(Tags tag, Color color, bool isClear) {
      if (isClear) {
        return SpeedDialChild(
          labelWidget: Container(
            padding: EdgeInsets.only(bottom: 3, top: 3, left: 5, right: 5),
            margin: EdgeInsets.only(bottom: 20),
            color: color,
            child: Text(
              tagToNameMap[tag],
              style: TextStyle(
                  fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 18),
            ),
          ),
          label: tagToNameMap[tag],
          onTap: () {
            currentFilter = tagToNameMap[tag];
            context.read<FilterBloc>().add(ClearFilter(tag));
          },
          labelBackgroundColor: color,
        );
      } else {
        return SpeedDialChild(
          labelWidget: Container(
            padding: EdgeInsets.only(bottom: 3, top: 3, left: 5, right: 5),
            color: color,
            child: Text(
              tagToNameMap[tag],
              style: TextStyle(
                  fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 18),
            ),
          ),
          label: tagToNameMap[tag],
          onTap: () {
            currentFilter = tagToNameMap[tag];
            context.read<FilterBloc>().add(FilterChecker(tag));
          },
          labelBackgroundColor: color,
        );
      }
    }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            myStream();
          },
              icon: Icon(Icons.wifi_protected_setup))
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        backwardsCompatibility: false,
        backgroundColor: primaryColorLight,
        title: Row(
          children: [
            Text(
              "DTM",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Visibility(
              visible: !isOnlineVar,
              child: Text(
                "Оффлайн",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          ],
        ),
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
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: isOnlineVar,
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: primaryColor,
                ),
                onPressed: createTask,
                backgroundColor: Utils.tagColor(
                    isWhite: false, isDetail: false, drpv: currentFilter),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SpeedDial(
              child: Icon(Icons.filter_list),
              overlayColor: Colors.black.withOpacity(0.8),
              childMargin: EdgeInsets.only(top: 3, bottom: 3),
              childPadding: EdgeInsets.all(3),
              children: [
                mySpeedDialChild(Tags.CLEAR, clearColor, true),
                mySpeedDialChild(Tags.FLUTTER, flutterColor, false),
                mySpeedDialChild(Tags.DART, dartColor, false),
                mySpeedDialChild(Tags.ALGORITHMS, algosColor, false),
                mySpeedDialChild(Tags.EXPIRED, Colors.grey, false),
              ],
              backgroundColor: Utils.tagColor(
                  isWhite: false, isDetail: false, drpv: currentFilter),
            ),
          ],
        ),
      ),
      backgroundColor: primaryColor,
    );
  }

  void snackBarDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      content: Text('Обновлено.'),
      action: SnackBarAction(
        label: 'Повторить',
        onPressed: () {
          var connectivityResult =
              Connectivity().checkConnectivity().then((value) {
            if (value == ConnectivityResult.none) {
            //  snackBarDisplay();
              print("here");
            } else {
              print("exit");
              setState(() {});
            }
          });
        },
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    // var connectivityResult = Connectivity().checkConnectivity().then((value) {
    //    if (value == ConnectivityResult.none) {
    //      //snackBarDisplay();
    //      print("none");
    //      Hive.openBox('taskList').then((listBox) {
    //        if (listBox.get('task') == null) {
    //          List<Task> taskList = [];
    //          listBox.put('task', taskList);
    //        } else {
    //          List<Task> hiveTasks = listBox.get('task').cast<Task>();
    //          context.read<TaskListBloc>().add(HiveChecker(hiveTasks));
    //        }
    //        listBox.close();
    //      });
    //    } else {
    //
    //      print("connected");
    //    }
    //});
  }
}
