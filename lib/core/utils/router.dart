import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/core/utils/page_router.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/presentation/pages/login/login_page.dart';
import 'package:taskmanager/presentation/pages/task_input/task_input_page.dart';
import 'package:taskmanager/presentation/pages/task_list/task_list_page.dart';

// The route configuration.
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 800),
        child: TaskListPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 800),
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.taskInput,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 800),
        child: TaskInputPage(
          task: state.extra as TaskEntity?,
        ),
      ),
    ),
  ],
  redirect: (context, state) async {
    final secureStorageService = SecureStorageService();

    final token = await secureStorageService.getUser();
    final isLoggedIn = token?.isNotEmpty == true;

    if (!isLoggedIn) {
      return AppRoutes.login;
    } else {
      return state.path;
    }
  },
);

List<String> routeHistory = [];
