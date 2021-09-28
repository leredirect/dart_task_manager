import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/screens/login_screen.dart';
import 'package:dart_task_manager/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/connectivity_bloc/connectivity_event.dart';
import 'bloc/filter_bloc/filter_bloc.dart';
import 'bloc/navigator_bloc/navigator_bloc.dart';
import 'bloc/user_bloc/user_bloc.dart';
import 'bloc/validation_bloc/login_bloc.dart';
import 'bloc/validation_bloc/registration_bloc.dart';
import 'bloc/validation_bloc/task_data_bloc/task_data_bloc.dart';
import 'models/task.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(TaskAdapter())
      ..registerAdapter(TagsAdapter())
      ..registerAdapter(UserAdapter());
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.instance.subscribeToTopic("scheduled");
    FirebaseMessaging.instance.getToken().then((value) {
      print("=============================\n=================\n$value");
    });

    return BlocProvider<NavigatorBloc>(
      create: (BuildContext context) => NavigatorBloc(navigatorKey: _navKey),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<ConnectivityBloc>(
                create: (context) => ConnectivityBloc()),
            BlocProvider<LoginFormBloc>(create: (context) => LoginFormBloc()),
            BlocProvider<RegistrationFormBloc>(
                create: (context) => RegistrationFormBloc()),
            BlocProvider<TaskDataBloc>(create: (context) => TaskDataBloc()),
            BlocProvider<TaskListBloc>(create: (context) => TaskListBloc()),
            BlocProvider<UserBloc>(create: (context) => UserBloc()),
            BlocProvider<FilterBloc>(create: (context) => FilterBloc())
          ],
          child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: MaterialApp(
                navigatorKey: _navKey,
                initialRoute: '/',
                routes: {
                  '/': (context) => const LoginScreen(),
                  'registrationScreen': (context) => const RegistrationScreen(),
                  'homeScreen': (context) => const HomeScreen(),
                },
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              ))),
    );
  }

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        _navKey.currentContext.read<ConnectivityBloc>().add(OfflineEvent());
      } else {
        _navKey.currentContext.read<ConnectivityBloc>().add(OnlineEvent());
      }
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _navKey.currentContext.read<ConnectivityBloc>().add(OfflineEvent());
      } else {
        _navKey.currentContext.read<ConnectivityBloc>().add(OnlineEvent());
      }
    });
  }
}
