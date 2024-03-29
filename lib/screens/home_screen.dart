import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_event.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_event.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/task_repo.dart';
import 'package:dart_task_manager/screens/create_new_task_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/grid_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:smart_select/smart_select.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentFilter = tagToNameMap[Tags.CLEAR];
  List<Tags> tagValue = [Tags.CLEAR];
  List<S2Choice<int>> s2Options = Utils.s2TagsList();

  Future<void> userSignOut() async {
    context.read<UserBloc>().add(ClearUserEvent());
    var listBox = await Hive.openBox<User>('userBox');
    listBox.clear();
    listBox.close();
    Navigator.pushReplacementNamed(context, "/");
  }

  void createTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return CreateNewTaskScreen();
      },
    ));
  }

  SpeedDialChild mySpeedDialChild(
      Tags tag, Color color, bool isClear, currentFilter) {
    return SpeedDialChild(
      labelWidget: Container(
        padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
        margin: EdgeInsets.only(bottom: 20),
        color: backgroundColor,
        child: Text(
          tagToNameMap[tag],
          style: headerText,
        ),
      ),
      label: tagToNameMap[tag],
      onTap: () {
        if (isClear) {
          currentFilter = tagToNameMap[tag];
          context.read<FilterBloc>().add(ClearFilter(Tags.CLEAR));
        } else {
          currentFilter = tagToNameMap[tag];
          context.read<FilterBloc>().add(FilterChecker(tag));
        }
      },
      labelBackgroundColor: color,
    );
  }

  Future<void> myStream() async {
    var taskBox = await Hive.openBox('taskList');
    List<Task> tasks = [];
    Future<QuerySnapshot> collection = TaskRepository().getStream();
    collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
      });
      context.read<TaskListBloc>().add(HiveChecker(tasks));
      taskBox.clear();
      taskBox.put('task', tasks);
      taskBox.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Function> menuOptions = {
      'Выход': userSignOut,
    };

    Utils.statusBarColor();
    return BlocBuilder<ConnectivityBloc, bool>(
        builder: (context, connectivityState) {
      if (connectivityState == true) {
        myStream();
      }
      return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              color: backgroundColor,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: (String value) async {
                menuOptions[value]();
              },
              itemBuilder: (BuildContext context) {
                return menuOptions.keys.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: standartText),
                  );
                }).toList();
              },
            ),
          ],
          systemOverlayStyle: Utils.statusBarColor(),
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              Text("DTM", style: headerText),
              Spacer(),
              Visibility(
                visible: !connectivityState,
                child: Text("Оффлайн", style: standartText),
              )
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        floatingActionButton: Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: createTask,
            backgroundColor: snackBarColor,
          ),
          SizedBox(
            width: 10,
          ),
          SpeedDial(
            backgroundColor: snackBarColor,
            child: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            overlayColor: Colors.black.withOpacity(0.8),
            childMargin: EdgeInsets.only(top: 3, bottom: 3),
            childPadding: EdgeInsets.all(3),
            children: [
              mySpeedDialChild(Tags.CLEAR, clearColor, true, currentFilter),
              mySpeedDialChild(
                  Tags.FLUTTER, taskColorDark, false, currentFilter),
              mySpeedDialChild(Tags.DART, taskColorDark, false, currentFilter),
              mySpeedDialChild(
                  Tags.ALGORITHMS, clearColor, false, currentFilter),
            ],
          ),
        ])),
        body: RefreshIndicator(
          displacement: 40,
          onRefresh: () async {
            await myStream();
            snackBarNotification(context, "обновлено");
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate("высокий приоритет"),
                pinned: true,
              ),
              BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
                return BlocBuilder<TaskListBloc, List<Task>>(
                    builder: (context, state) {
                  return GridViewWidget(state, filtState, Priorities.HIGH);
                });
              }),
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate("средний приоритет"),
                pinned: true,
              ),
              BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
                return BlocBuilder<TaskListBloc, List<Task>>(
                    builder: (context, state) {
                  return GridViewWidget(state, filtState, Priorities.MEDIUM);
                });
              }),
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate("низкий приоритет"),
                pinned: true,
              ),
              BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
                return BlocBuilder<TaskListBloc, List<Task>>(
                    builder: (context, state) {
                  return GridViewWidget(state, filtState, Priorities.LOW);
                });
              }),
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate("просроченные"),
                pinned: true,
              ),
              BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
                return BlocBuilder<TaskListBloc, List<Task>>(
                    builder: (context, state) {
                  return GridViewWidget(state, filtState);
                });
              }),
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    List<Task> tasks = [];
    Future<QuerySnapshot> collection = TaskRepository().getStream();
    collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
      });
      context.read<TaskListBloc>().add(HiveChecker(tasks));
    });
    bool isOnline = context.read<ConnectivityBloc>().state;
    if (!isOnline) {
      Hive.openBox('taskList').then((value) {
        if (value.isNotEmpty) {
          List<Task> hiveTasks = value.get('task').cast<Task>();
          context.read<TaskListBloc>().add(HiveChecker(hiveTasks));
        }
        value.close();
      });
    } else {
      myStream();
    }
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  SectionHeaderDelegate(this.title, [this.height = 35]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: backgroundColor,
              spreadRadius: 3,
              blurRadius: 0,
              offset: Offset(0, 0),
            ),
          ]),
      padding: EdgeInsets.only(left: 30),
      alignment: Alignment.center,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: headerText,
            textAlign: TextAlign.start,
          )),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
