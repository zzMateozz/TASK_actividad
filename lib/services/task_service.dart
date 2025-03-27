import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
  final String baseUrl = "https://api.ejemplo.com/tasks"; // Reemplazar con tu API

  // Obtener todas las tareas
  Future<List<TaskModel>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      throw Exception("Error al obtener las tareas");
    }
  }

  // Crear una nueva tarea
  Future<TaskModel?> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  // Actualizar una tarea
  Future<TaskModel?> updateTask(TaskModel task, Map<String, String> map) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  // Eliminar una tarea
  Future<bool> deleteTask(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    return response.statusCode == 200;
  }
}
