import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/views/widgets/task_item_widget.dart';
import 'task_create_page.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskController>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas'),
      ),
      body: Consumer<TaskController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.tasks.isEmpty) {
            return Center(
              child: Text('No hay tareas'),
            );
          }

          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return TaskItemWidget(
                task: task,
                onDelete: () => controller.removeTask(task.id!),
                onStatusChange: (newStatus) => 
                  controller.updateTaskStatus(task, newStatus),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => TaskCreatePage())
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}