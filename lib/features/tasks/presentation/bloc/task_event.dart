part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TasksRequested extends TaskEvent {
  const TasksRequested(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

class TasksRefreshed extends TaskEvent {
  const TasksRefreshed();
}

class TasksCleared extends TaskEvent {
  const TasksCleared();
}

class TaskCreated extends TaskEvent {
  const TaskCreated(this.draft);

  final TaskDraft draft;

  @override
  List<Object?> get props => [draft];
}

class TaskUpdated extends TaskEvent {
  const TaskUpdated(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class TaskCompletionToggled extends TaskEvent {
  const TaskCompletionToggled(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskEvent {
  const TaskDeleted(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class TaskFeedbackCleared extends TaskEvent {
  const TaskFeedbackCleared();
}
