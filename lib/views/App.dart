import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/views/pages/task_list_page.dart';
import 'package:task/views/pages/task_create_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // CAMBIO A GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [ // CAMBIO A getPages PARA SOPORTAR GetX NAVIGATION
        GetPage(name: '/', page: () => TaskListPage()),
        GetPage(name: '/createTask', page: () => TaskCreatePage()),
      ],
    );
  }
}
