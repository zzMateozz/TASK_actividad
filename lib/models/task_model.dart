import 'package:flutter/material.dart';

class TaskModel {
  final String? id;
  final String nombre;
  final String detalle;
  final TaskStatus estado;

  TaskModel({
    this.id,
    required this.nombre,
    required this.detalle,
    this.estado = TaskStatus.pendiente,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    nombre: json['nombre'],
    detalle: json['detalle'],
    estado: TaskStatus.values.byName(json['estado'] ?? 'pendiente'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'detalle': detalle,
    'estado': estado.name,
  };

  TaskModel copyWith({
    String? id,
    String? nombre,
    String? detalle,
    TaskStatus? estado,
  }) => TaskModel(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    detalle: detalle ?? this.detalle,
    estado: estado ?? this.estado,
  );
}

enum TaskStatus {
  pendiente,
  en_progreso,
  completada;

  // Método de extensión para mostrar nombres formateados
  String get displayName {
    switch (this) {
      case TaskStatus.pendiente:
        return 'Pendiente';
      case TaskStatus.en_progreso:
        return 'En Progreso';
      case TaskStatus.completada:
        return 'Completada';
    }
  }

  // Método de extensión para obtener iconos
  IconData get icon {
    switch (this) {
      case TaskStatus.pendiente:
        return Icons.access_time;
      case TaskStatus.en_progreso:
        return Icons.play_arrow;
      case TaskStatus.completada:
        return Icons.check_circle;
    }
  }

  // Método de extensión para colores
  Color get color {
    switch (this) {
      case TaskStatus.pendiente:
        return Colors.orange;
      case TaskStatus.en_progreso:
        return Colors.blue;
      case TaskStatus.completada:
        return Colors.green;
    }
  }
}