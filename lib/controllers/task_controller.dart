import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/models/task_model.dart';
import 'package:task/services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find();
  final RxString searchQuery = ''.obs;
  final Rx<TaskStatus?> filterStatus = Rx<TaskStatus?>(null);
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>(); // Para manejar mensajes de error

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);
      final fetchedTasks = await _taskService.getTasks();
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      // Modifica el snackbar para manejar mejor las animaciones
      Get.closeAllSnackbars(); // Cierra cualquier snackbar previo
      Get.snackbar(
        'Error',
        'No se pudieron cargar las tareas',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 300),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      isLoading(true);
      error(null);
      final newTask = await _taskService.createTask(task);
      tasks.add(newTask);
      Get.back();
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', 'No se pudo crear la tarea',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateTask(int index, TaskModel updatedTask) async {
    try {
      if (updatedTask.id == null) return;
      
      isLoading(true);
      error(null);
      final task = await _taskService.updateTask(updatedTask.id!, updatedTask);
      tasks[index] = task;
      Get.back();
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', 'No se pudo actualizar la tarea',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    try {
      if (task.id == null) {
        throw Exception('La tarea no tiene un ID válido');
      }
      
      isLoading(true);
      error(null);
      await _taskService.deleteTask(task.id!);
      tasks.removeWhere((t) => t.id == task.id); // Mejor forma de eliminar
      
      Get.closeAllSnackbars();
      Get.snackbar(
        'Éxito',
        'Tarea eliminada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error(e.toString());
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'No se pudo eliminar la tarea: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  
  List<TaskModel> get filteredTasks {
    return tasks.where((task) {
      // Filtro por búsqueda
      final matchesSearch = searchQuery.value.isEmpty || 
          task.nombre.toLowerCase().contains(searchQuery.value.toLowerCase()) || 
          task.detalle.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      // Filtro por estado (si no es null muestra todos)
      final matchesStatus = filterStatus.value == null || 
          task.estado == filterStatus.value;
      
      return matchesSearch && matchesStatus;
    }).toList();
  }
  void clearFilters() {
    searchQuery.value = '';
    filterStatus.value = null;
  }
  
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  void setFilterStatus(TaskStatus? status) {
    filterStatus.value = status;
  }
}
