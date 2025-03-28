import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/task_controller.dart';

import 'pages/task_create_page.dart';
import 'pages/task_list_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => TaskListPage()),
        GetPage(name: '/createTask', page: () => TaskCreatePage()),
      ],
      builder: (context, child) {
        return Scaffold(
          body: Obx(() {
            final error = Get.find<TaskController>().error.value;
            if (error != null) {
              return Center(child: Text('Error: $error'));
            }
            return child!;
          }),
        );
      },
    );
  }
}