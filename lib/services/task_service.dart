
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task/models/task_model.dart';

class TaskService extends GetxService {
  static const String baseUrl = 'https://67e5e30d18194932a5878636.mockapi.io/api/v1/task_app'; // Reemplaza con tu URL
  final http.Client httpClient = http.Client();

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await httpClient.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await httpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 201) {
        return TaskModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  Future<TaskModel> updateTask(String id, TaskModel task) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        return TaskModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/$id'),
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        // Mostrar más detalles del error
        throw Exception('Failed to delete task. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting task: ${e.toString()}');
    }
  }
}