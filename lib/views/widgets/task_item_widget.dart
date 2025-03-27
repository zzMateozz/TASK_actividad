import 'package:flutter/material.dart';
import 'package:task/models/task_model.dart';
import 'package:task/utils/constants.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChange;

  const TaskItemWidget({
    Key? key, 
    required this.task, 
    required this.onDelete,
    required this.onStatusChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.nombre),
        subtitle: Text(task.detalle),
        trailing: DropdownButton<TaskStatus>(
          value: task.estado,
          onChanged: (TaskStatus? newStatus) {
            if (newStatus != null) {
              onStatusChange(newStatus);
            }
          },
          items: TaskStatus.values
            .map((status) => DropdownMenuItem(
              value: status,
              child: Text(
                status.name.toUpperCase(),
                style: TextStyle(
                  color: AppConstants.statusColors[status]
                ),
              ),
            ))
            .toList(),
        ),
        leading: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}