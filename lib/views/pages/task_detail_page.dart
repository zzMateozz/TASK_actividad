import 'package:flutter/material.dart';
import 'package:task/models/task_model.dart';
import 'task_create_page.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskModel task;

  const TaskDetailPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Tarea'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskCreatePage(existingTask: task)
                )
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.nombre,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              'Detalle:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              task.detalle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Estado:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Chip(
              label: Text(task.estado.name.toUpperCase()),
              backgroundColor: _getStatusColor(task.estado),
            ),
            SizedBox(height: 16),
            Text(
              'ID de Tarea:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              task.id ?? 'Sin ID',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pendiente:
        return Colors.orange.shade100;
      case TaskStatus.en_progreso:
        return Colors.blue.shade100;
      case TaskStatus.completada:
        return Colors.green.shade100;
    }
  }
}