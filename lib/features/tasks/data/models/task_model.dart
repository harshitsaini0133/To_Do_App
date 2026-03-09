import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.completed,
    super.description,
    super.dueDate,
  });

  factory TaskModel.fromFirebaseJson(
    String id,
    Map<String, dynamic> json,
  ) {
    return TaskModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      dueDate: DateTime.tryParse(json['dueDate'] as String? ?? ''),
      completed: json['completed'] as bool? ?? false,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completed: task.completed,
    );
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
    };
  }

  static Map<String, dynamic> createPayload(TaskDraft draft, DateTime createdAt) {
    return {
      'title': draft.title.trim(),
      'description': draft.description?.trim().isEmpty ?? true
          ? null
          : draft.description?.trim(),
      'createdAt': createdAt.toIso8601String(),
      'dueDate': draft.dueDate?.toIso8601String(),
      'completed': false,
    };
  }
}
