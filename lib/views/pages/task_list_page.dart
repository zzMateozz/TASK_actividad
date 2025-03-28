import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/models/task_model.dart';
import 'package:task/views/pages/task_create_page.dart';

class TaskListPage extends StatelessWidget {
  final TaskController tc = Get.find();
  final Rxn<int> selectedIndex = Rxn<int>();
  final ScrollController _scrollController = ScrollController();
  final RxBool showSearch = false.obs;

  TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        if (showSearch.value) {
          return TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Buscar tareas...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  tc.setSearchQuery('');
                  showSearch.value = false;
                },
              ),
            ),
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onChanged: tc.setSearchQuery,
          );
        } else {
          return const Text(
            'Mis Tareas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          );
        }
      }),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.3),
      actions: [
        _buildFilterButton(),
        Obx(() => IconButton(
          icon: Icon(showSearch.value ? Icons.close : Icons.search),
          onPressed: () {
            if (showSearch.value) {
              tc.setSearchQuery('');
            }
            showSearch.value = !showSearch.value;
          },
          tooltip: 'Buscar',
        )),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'Actualizar',
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Obx(() => Badge(
      isLabelVisible: tc.filterStatus.value != null,
      child: PopupMenuButton<TaskStatus>(
        icon: const Icon(Icons.filter_list),
        tooltip: 'Filtrar por estado',
        onSelected: (status) {
          // Cuando se selecciona "Todos los estados" (status = null)
          // se limpia el filtro de estado
          tc.setFilterStatus(status);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: null,
            child: Text('Todos los estados'),
          ),
          ...TaskStatus.values.map((status) => PopupMenuItem(
                value: status,
                child: Row(
                  children: [
                    Icon(status.icon, color: status.color),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
              )),
        ],
      ),
    ));
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildActiveFiltersChips(),
        Expanded(
          child: Obx(() {
            if (tc.isLoading.value && tc.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tc.error.value != null) {
              return _buildErrorView();
            }

            if (tc.tasks.isEmpty) {
              return _buildEmptyView();
            }

            return _buildTaskList();
          }),
        ),
      ],
    );
  }

  Widget _buildActiveFiltersChips() {
    return Obx(() {
      if (tc.searchQuery.isEmpty && tc.filterStatus.value == null) {
        return const SizedBox();
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Wrap(
          spacing: 8,
          children: [
            if (tc.searchQuery.isNotEmpty)
              Chip(
                label: Text('Buscar: "${tc.searchQuery}"'),
                onDeleted: () => tc.setSearchQuery(''),
              ),
            if (tc.filterStatus.value != null)
              Chip(
                label: Text('Estado: ${tc.filterStatus.value!.displayName}'),
                deleteIcon: Icon(tc.filterStatus.value!.icon, 
                              color: tc.filterStatus.value!.color),
                onDeleted: () => tc.setFilterStatus(null), // Limpia este filtro
              ),
            if (tc.searchQuery.isNotEmpty || tc.filterStatus.value != null)
              ActionChip(
                label: const Text('Limpiar todo'),
                onPressed: tc.clearFilters,
                avatar: const Icon(Icons.clear, size: 18),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Error: ${tc.error.value}',
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            onPressed: _refreshData,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment, color: Colors.grey, size: 50),
          const SizedBox(height: 16),
          Obx(() {
            if (tc.searchQuery.isNotEmpty || tc.filterStatus.value != null) {
              return const Text(
                'No hay tareas que coincidan con los filtros',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              );
            } else {
              return const Text(
                'No hay tareas disponibles',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              );
            }
          }),
          const SizedBox(height: 8),
          if (tc.searchQuery.isNotEmpty || tc.filterStatus.value != null)
            TextButton(
              onPressed: tc.clearFilters,
              child: const Text('Mostrar todas las tareas'),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Obx(() {
        if (tc.filteredTasks.isEmpty) {
          return _buildEmptyView();
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: tc.filteredTasks.length,
          itemBuilder: (context, index) => 
              _buildTaskItem(tc.filteredTasks[index], index),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        );
      }),
    );
  }

  Widget _buildTaskItem(TaskModel task, int index) {
    final isSelected = selectedIndex.value == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _getTaskCardColor(task.estado),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _toggleTaskSelection(index),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatusIndicator(task.estado),
                const SizedBox(width: 16),
                Expanded(child: _buildTaskDetails(task)),
                _buildSelectionIndicator(isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTaskCardColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pendiente:
        return Colors.orange[50]!;
      case TaskStatus.en_progreso:
        return Colors.blue[50]!;
      case TaskStatus.completada:
        return Colors.green[50]!;
    }
  }

  Widget _buildStatusIndicator(TaskStatus status) {
    return Container(
      width: 8,
      height: 40,
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTaskDetails(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          task.detalle,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: task.estado.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.estado.displayName,
            style: TextStyle(
              color: task.estado.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return AnimatedOpacity(
      opacity: isSelected ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: const Icon(Icons.check_circle, color: Colors.blue),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Obx(() {
      if (tc.isLoading.value) {
        return FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.blueAccent.withOpacity(0.5),
          child: const CircularProgressIndicator(color: Colors.white),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (selectedIndex.value != null) ...[
            FloatingActionButton(
              heroTag: 'delete',
              backgroundColor: Colors.red[400],
              onPressed: _confirmDeleteTask,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'edit',
              backgroundColor: Colors.orange[400],
              onPressed: _editSelectedTask,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _navigateToCreatePage,
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      );
    });
  }

  Future<void> _refreshData() async {
    selectedIndex.value = null;
    await tc.fetchTasks();
  }

  void _toggleTaskSelection(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

  void _navigateToCreatePage() {
    Get.to(() => TaskCreatePage());
  }

  void _confirmDeleteTask() {
    Get.defaultDialog(
      title: 'Confirmar eliminación',
      titlePadding: const EdgeInsets.only(top: 16),
      middleText: '¿Estás seguro de eliminar esta tarea?',
      middleTextStyle: const TextStyle(fontSize: 16),
      textConfirm: 'Eliminar',
      textCancel: 'Cancelar',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        tc.deleteTask(tc.tasks[selectedIndex.value!]);
        selectedIndex.value = null;
        Get.back();
      },
    );
  }

  void _editSelectedTask() {
    Get.to(() => TaskCreatePage(
      task: tc.tasks[selectedIndex.value!],
      index: selectedIndex.value!,
    ));
  }
}