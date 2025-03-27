import 'package:get/get.dart';
import 'package:task/models/task_model.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs; // Lista reactiva de tareas

  // Agregar una nueva tarea
  void addTask(TaskModel task) {
    tasks.add(task);
  }

  // Actualizar una tarea existente
  void updateTask(int index, TaskModel updatedTask) {
    // Actualiza la tarea existente en lugar de reemplazarla
    tasks[index] = updatedTask.copyWith(
      nombre: updatedTask.nombre,
      detalle: updatedTask.detalle,
      estado: updatedTask.estado
    );
  }

  // Eliminar una tarea
  void deleteTask(TaskModel task) {
    tasks.remove(task);
  }
}
