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
    final TextEditingController txtNombre = TextEditingController(text: task?.nombre ?? '');
    final TextEditingController txtDetalle = TextEditingController(text: task?.detalle ?? '');
    final Rx<TaskStatus> selectedStatus = Rx<TaskStatus>(task?.estado ?? TaskStatus.pendiente);

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Crear Tarea' : 'Editar Tarea'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNombreField(txtNombre),
            const SizedBox(height: 16),
            _buildDetalleField(txtDetalle),
            const SizedBox(height: 16),
            _buildStatusDropdown(selectedStatus),
            const SizedBox(height: 30),
            _buildSubmitButton(txtNombre, txtDetalle, selectedStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildNombreField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Nombre de la tarea',
        prefixIcon: Icon(Icons.task),
        border: OutlineInputBorder(),
      ),
      maxLength: 50,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDetalleField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Detalle de la tarea',
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      maxLength: 200,
    );
  }

  Widget _buildStatusDropdown(Rx<TaskStatus> selectedStatus) {
    return Obx(() => DropdownButtonFormField<TaskStatus>(
      value: selectedStatus.value,
      decoration: const InputDecoration(
        labelText: 'Estado de la tarea',
        prefixIcon: Icon(Icons.flag),
        border: OutlineInputBorder(),
      ),
      items: TaskStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Row(
            children: [
              Icon(
                status.icon,
                color: status.color,
              ),
              const SizedBox(width: 8),
              Text(status.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          selectedStatus.value = newStatus;
        }
      },
    ));
  }

  Widget _buildSubmitButton(
    TextEditingController nombreController,
    TextEditingController detalleController,
    Rx<TaskStatus> status
  ) {
    return Obx(() {
      final isLoading = tc.isLoading.value;
      
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _handleSubmit(nombreController, detalleController, status),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  task == null ? 'Agregar Tarea' : 'Guardar Cambios',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }

  void _handleSubmit(
    TextEditingController nombreController,
    TextEditingController detalleController,
    Rx<TaskStatus> status
  ) {
    final nombre = nombreController.text.trim();
    final detalle = detalleController.text.trim();

    if (nombre.isEmpty || detalle.isEmpty) {
      Get.snackbar(
        'Error',
        'Todos los campos son obligatorios',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final updatedTask = TaskModel(
      id: task?.id,
      nombre: nombre,
      detalle: detalle,
      estado: status.value,
    );

    if (task != null && index != null) {
      tc.updateTask(index!, updatedTask);
    } else {
      tc.addTask(updatedTask);
    }
  }
}