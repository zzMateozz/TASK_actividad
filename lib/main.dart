// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/services/task_service.dart';
import 'package:task/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa los servicios
  Get.put(TaskService());
  Get.put(TaskController());
  
  runApp(MyApp());
}