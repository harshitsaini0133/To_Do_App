import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.completed,
    this.description,
    this.dueDate,
  });

  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool completed;

  bool get hasDescription => description != null && description!.trim().isNotEmpty;
  bool get hasDueDate => dueDate != null;
  bool get isOverdue =>
      dueDate != null &&
      !completed &&
      dueDate!.isBefore(DateTime.now().subtract(const Duration(days: 1)));

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? completed,
    bool clearDescription = false,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        dueDate,
        completed,
      ];
}
