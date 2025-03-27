import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/services/task_service.dart';
import 'package:task/views/pages/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskController(TaskService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TaskListPage(),
      ),
    );
  }
}