import 'package:equatable/equatable.dart';

class TaskDraft extends Equatable {
  const TaskDraft({
    required this.title,
    this.description,
    this.dueDate,
  });

  final String title;
  final String? description;
  final DateTime? dueDate;

  @override
  List<Object?> get props => [title, description, dueDate];
}
