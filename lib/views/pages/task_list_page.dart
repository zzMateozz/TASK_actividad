import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/models/task_model.dart';
import 'package:task/views/pages/task_create_page.dart';

class TaskListPage extends StatelessWidget {
  final TaskController tc = Get.put(TaskController());
  final Rxn<int> selectedIndex = Rxn<int>();

  TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Tareas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
      ),
      body: Obx(() => ListView.builder(
        itemCount: tc.tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = tc.tasks[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                // Seleccionar o deseleccionar la tarea
                selectedIndex.value = selectedIndex.value == index ? null : index;
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Icono del estado de la tarea
                    Icon(
                      task.estado == TaskStatus.pendiente
                          ? Icons.access_time
                          : task.estado == TaskStatus.en_progreso
                              ? Icons.play_arrow
                              : Icons.check_circle,
                      color: task.estado == TaskStatus.pendiente
                          ? Colors.orange
                          : task.estado == TaskStatus.en_progreso
                              ? Colors.blue
                              : Colors.green,
                      size: 30,
                    ),
                    SizedBox(width: 16),
                    // Detalles de la tarea
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            task.detalle,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        physics: BouncingScrollPhysics(),
      )),
      floatingActionButton: Obx(() {
        if (selectedIndex.value != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  // Eliminar la tarea seleccionada
                  tc.deleteTask(tc.tasks[selectedIndex.value!]);
                  selectedIndex.value = null;
                },
                child: Icon(Icons.delete, color: Colors.white),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  Get.to(
                    TaskCreatePage(
                      task: tc.tasks[selectedIndex.value!],
                      index: selectedIndex.value!, // Pasa el índice aquí
                    ),
                  );
                },
                child: Icon(Icons.edit, color: Colors.white),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  Get.to(TaskCreatePage());
                },
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              Get.to(TaskCreatePage());
            },
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.add, color: Colors.white),
          );
        }
      }),
    );
  }
}