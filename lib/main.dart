import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/screens/login_screen.dart';
import 'package:dart_task_manager/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/filter_bloc/filter_bloc.dart';
import 'bloc/user_bloc/user_bloc.dart';
import 'bloc/validation_bloc/login_bloc.dart';
import 'bloc/validation_bloc/registration_bloc.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegistrationFormBloc>(create: (context) => RegistrationFormBloc()),
          BlocProvider<LoginFormBloc>(create: (context) => LoginFormBloc()),
          BlocProvider<TaskListBloc>(create: (context) => TaskListBloc()),
          BlocProvider<UserBloc>(create: (context) => UserBloc()),
          BlocProvider<FilterBloc>(create: (context) => FilterBloc())
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: MaterialApp(
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
            )));
  }
}
