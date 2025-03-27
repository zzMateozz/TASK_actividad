import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../utils/constants.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService;
  
  List<TaskModel> tasks = [];
  bool isLoading = false;

  TaskController(this._taskService);

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    
    tasks = await _taskService.getAllTasks();
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    final newTask = await _taskService.createTask(task);
    tasks.add(newTask);
    notifyListeners();
  }

  Future<void> removeTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    final updatedTask = await _taskService.updateTask(task);
    if (updatedTask != null) {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        notifyListeners();
      }
    }
  }

  Future<void> updateTaskStatus(TaskModel task, TaskStatus newStatus) async {
    final updatedTask = task.copyWith(estado: newStatus);
    await updateTask(updatedTask);
  }
}