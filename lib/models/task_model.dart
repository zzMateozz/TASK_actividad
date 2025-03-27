
class TaskModel {
  final String? id;
  final String nombre;
  final String detalle;
  final TaskStatus estado;

  TaskModel({
    this.id,
    required this.nombre,
    required this.detalle,
    this.estado = TaskStatus.pendiente
  });

  // Constructor para crear desde JSON
  TaskModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nombre = json['nombre'],
      detalle = json['detalle'],
      estado = TaskStatus.values.byName(json['estado'] ?? 'pendiente');

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'detalle': detalle,
    'estado': estado.name
  };

  // Método para clonar y modificar
  TaskModel copyWith({
    String? id,
    String? nombre,
    String? detalle,
    TaskStatus? estado
  }) {
    return TaskModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      detalle: detalle ?? this.detalle,
      estado: estado ?? this.estado
    );
  }
}

enum TaskStatus {
  pendiente,
  en_progreso,
  completada
}