import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/models/task_model.dart';
import '../widgets/custom_input_widget.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskModel? existingTask;

  const TaskCreatePage({Key? key, this.existingTask}) : super(key: key);

  @override
  _TaskCreatePageState createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  late TextEditingController _nombreController;
  late TextEditingController _detalleController;
  TaskStatus _selectedStatus = TaskStatus.pendiente;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.existingTask?.nombre ?? ''
    );
    _detalleController = TextEditingController(
      text: widget.existingTask?.detalle ?? ''
    );
    
    if (widget.existingTask != null) {
      _selectedStatus = widget.existingTask!.estado;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre de la tarea es obligatorio'))
      );
      return;
    }

    final taskController = Provider.of<TaskController>(context, listen: false);
    
    final task = TaskModel(
      id: widget.existingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreController.text,
      detalle: _detalleController.text,
      estado: _selectedStatus
    );

    if (widget.existingTask == null) {
      taskController.addTask(task).then((_) {
        Navigator.pop(context, true); // Retorna un valor para recargar la lista
      });
    } else {
      taskController.updateTask(task).then((_) {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask == null 
          ? 'Crear Nueva Tarea' 
          : 'Editar Tarea'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomInputWidget(
              controller: _nombreController,
              label: 'Nombre de la Tarea',
              hintText: 'Ingrese el nombre de la tarea',
              icon: Icons.title,
            ),
            SizedBox(height: 16),
            CustomInputWidget(
              controller: _detalleController,
              label: 'Detalle de la Tarea',
              hintText: 'Descripción de la tarea',
              icon: Icons.description,
              maxLines: 3,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<TaskStatus>(
              decoration: InputDecoration(
                labelText: 'Estado de la Tarea',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
              value: _selectedStatus,
              items: TaskStatus.values
                .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status.name.toUpperCase()),
                ))
                .toList(),
              onChanged: (status) {
                setState(() {
                  _selectedStatus = status!;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(
                widget.existingTask == null 
                  ? 'Crear Tarea' 
                  : 'Actualizar Tarea'
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}