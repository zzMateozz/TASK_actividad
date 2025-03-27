import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tasks.json');
  }

  Future<List<TaskModel>> getAllTasks() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> taskJsonList = json.decode(contents);
      return taskJsonList.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: task.nombre,
      detalle: task.detalle,
      estado: task.estado
    );
    tasks.add(newTask);
    await _saveTasksToFile(tasks);
    return newTask;
  }

  Future<TaskModel?> updateTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveTasksToFile(tasks);
      return task;
    }
    return null;
  }

  Future<bool> deleteTask(String taskId) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _saveTasksToFile(tasks);
    return true;
  }

  Future<void> _saveTasksToFile(List<TaskModel> tasks) async {
    final file = await _getLocalFile();
    final jsonString = json.encode(tasks.map((task) => task.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}