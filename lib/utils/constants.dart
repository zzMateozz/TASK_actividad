// Clase de constantes de la aplicación
import 'package:flutter/material.dart' show Color, Colors;
import 'package:task/models/task_model.dart';

class AppConstants {
  static const String appName = 'Task Manager';
  
  // Colores para los estados de tarea
  static Map<TaskStatus, Color> statusColors = {
    TaskStatus.pendiente: Colors.orange,
    TaskStatus.en_progreso: Colors.blue,
    TaskStatus.completada: Colors.green
  };
}