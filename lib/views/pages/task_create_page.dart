import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/models/task_model.dart';

class TaskCreatePage extends StatelessWidget {
  final TaskController tc = Get.find();
  final TaskModel? task;
  final int? index;

  TaskCreatePage({super.key, this.task, this.index});

 @override
  Widget build(BuildContext context) {
    final TextEditingController txtNombre =
        TextEditingController(text: task?.nombre ?? '');
    final TextEditingController txtDetalle =
        TextEditingController(text: task?.detalle ?? '');
    
    // Estado seleccionado
    final Rx<TaskStatus> selectedStatus =
        Rx<TaskStatus>(task?.estado ?? TaskStatus.pendiente);

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Crear Tarea' : 'Editar Tarea'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para el nombre de la tarea
            TextField(
              controller: txtNombre,
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                prefixIcon: Icon(Icons.task),
              ),
            ),
            SizedBox(height: 16),

            // Campo para el detalle de la tarea
            TextField(
              controller: txtDetalle,
              decoration: InputDecoration(
                labelText: 'Detalle de la tarea',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown para seleccionar el estado de la tarea
            Obx(() => DropdownButtonFormField<TaskStatus>(
                  value: selectedStatus.value,
                  decoration: InputDecoration(
                    labelText: 'Estado de la tarea',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status == TaskStatus.pendiente
                            ? 'Pendiente'
                            : status == TaskStatus.en_progreso
                                ? 'En Progreso'
                                : 'Completada',
                      ),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      selectedStatus.value = newStatus;
                    }
                  },
                )),
            SizedBox(height: 30),

            // Botón para agregar o editar tarea
            ElevatedButton(
              onPressed: () {
                if (txtNombre.text.isEmpty || txtDetalle.text.isEmpty) {
                  Get.snackbar('Error', 'Todos los campos son obligatorios',
                      backgroundColor: Colors.red, colorText: Colors.white);
                } else {
                  final updatedTask = TaskModel(
                    nombre: txtNombre.text,
                    detalle: txtDetalle.text,
                    estado: selectedStatus.value,
                  );

                  if (task != null && index != null) {
                    // Modo edición - usa el índice directamente
                    tc.updateTask(index!, updatedTask);
                  } else {
                    // Modo creación
                    tc.addTask(updatedTask);
                  }

                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                task == null ? 'Agregar Tarea' : 'Guardar Cambios',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}