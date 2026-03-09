part of 'task_bloc.dart';

enum TaskStatus { initial, loading, loaded, error }

class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.session,
    this.tasks = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.actionMessage,
  });

  final TaskStatus status;
  final AuthSession? session;
  final List<Task> tasks;
  final bool isSubmitting;
  final String? errorMessage;
  final String? actionMessage;

  TaskState copyWith({
    TaskStatus? status,
    AuthSession? session,
    List<Task>? tasks,
    bool? isSubmitting,
    String? errorMessage,
    String? actionMessage,
    bool clearSession = false,
    bool clearError = false,
    bool clearAction = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      tasks: tasks ?? this.tasks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionMessage: clearAction ? null : actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        session,
        tasks,
        isSubmitting,
        errorMessage,
        actionMessage,
      ];
}
