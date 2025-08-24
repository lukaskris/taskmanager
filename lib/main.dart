import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskmanager/core/service/connectivity_service.dart';
import 'package:taskmanager/core/theme/global_theme_data.dart';
import 'package:taskmanager/core/utils/my_http_override.dart';
import 'package:taskmanager/core/utils/router.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/injectable.dart';
import 'package:toastification/toastification.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark));

  final connectivityService = getIt<ConnectivityService>();
  final taskRepository = getIt<TaskRepository>();

  connectivityService.connectivityStream.listen((result) async {
    if (result) {
      await taskRepository.syncPendingTasks();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        // home: const LoginPage(),
      ),
    );
  }
}
