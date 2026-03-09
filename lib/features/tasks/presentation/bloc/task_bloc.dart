import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/api/api_error.dart';
import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';
import 'package:to_do_app/features/tasks/domain/usecases/create_task.dart';
import 'package:to_do_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:to_do_app/features/tasks/domain/usecases/load_tasks.dart';
import 'package:to_do_app/features/tasks/domain/usecases/toggle_task_completion.dart';
import 'package:to_do_app/features/tasks/domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required LoadTasks loadTasks,
    required CreateTask createTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required ToggleTaskCompletion toggleTaskCompletion,
  })  : _loadTasks = loadTasks,
        _createTask = createTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        _toggleTaskCompletion = toggleTaskCompletion,
        super(const TaskState()) {
    on<TasksRequested>(_onTasksRequested);
    on<TasksRefreshed>(_onTasksRefreshed);
    on<TasksCleared>(_onTasksCleared);
    on<TaskCreated>(_onTaskCreated);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskFeedbackCleared>(_onTaskFeedbackCleared);
  }

  final LoadTasks _loadTasks;
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskCompletion _toggleTaskCompletion;

  Future<void> _onTasksRequested(
    TasksRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        session: event.session,
        status: state.tasks.isEmpty ? TaskStatus.loading : TaskStatus.loaded,
        clearError: true,
        clearAction: true,
      ),
    );

    try {
      final tasks = await _loadTasks(event.session);
      emit(
        state.copyWith(
          session: event.session,
          status: TaskStatus.loaded,
          tasks: _sortTasks(tasks),
          isSubmitting: false,
          clearError: true,
          clearAction: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          session: event.session,
          status: state.tasks.isEmpty ? TaskStatus.error : TaskStatus.loaded,
          errorMessage: _messageFrom(error),
          isSubmitting: false,
          clearAction: true,
        ),
      );
    }
  }

  Future<void> _onTasksRefreshed(
    TasksRefreshed event,
    Emitter<TaskState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }
    add(TasksRequested(session));
  }

  void _onTasksCleared(
    TasksCleared event,
    Emitter<TaskState> emit,
  ) {
    emit(const TaskState());
  }

  Future<void> _onTaskCreated(
    TaskCreated event,
    Emitter<TaskState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearAction: true,
      ),
    );

    try {
      final task = await _createTask(session, event.draft);
      emit(
        state.copyWith(
          status: TaskStatus.loaded,
          tasks: _sortTasks([task, ...state.tasks]),
          isSubmitting: false,
          actionMessage: 'Task added',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.tasks.isEmpty ? TaskStatus.error : TaskStatus.loaded,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearAction: true,
        ),
      );
    }
  }

  Future<void> _onTaskUpdated(
    TaskUpdated event,
    Emitter<TaskState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearAction: true,
      ),
    );

    try {
      final task = await _updateTask(session, event.task);
      final tasks = state.tasks
          .map((item) => item.id == task.id ? task : item)
          .toList();
      emit(
        state.copyWith(
          status: TaskStatus.loaded,
          tasks: _sortTasks(tasks),
          isSubmitting: false,
          actionMessage: 'Task updated',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.tasks.isEmpty ? TaskStatus.error : TaskStatus.loaded,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearAction: true,
        ),
      );
    }
  }

  Future<void> _onTaskCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TaskState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearAction: true,
      ),
    );

    try {
      final task = await _toggleTaskCompletion(session, event.task);
      final tasks = state.tasks
          .map((item) => item.id == task.id ? task : item)
          .toList();
      emit(
        state.copyWith(
          status: TaskStatus.loaded,
          tasks: _sortTasks(tasks),
          isSubmitting: false,
          actionMessage: task.completed
              ? 'Task completed'
              : 'Task marked active',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.tasks.isEmpty ? TaskStatus.error : TaskStatus.loaded,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearAction: true,
        ),
      );
    }
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearAction: true,
      ),
    );

    try {
      await _deleteTask(session, event.task.id);
      final tasks = state.tasks.where((item) => item.id != event.task.id).toList();
      emit(
        state.copyWith(
          status: TaskStatus.loaded,
          tasks: tasks,
          isSubmitting: false,
          actionMessage: 'Task deleted',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.tasks.isEmpty ? TaskStatus.error : TaskStatus.loaded,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearAction: true,
        ),
      );
    }
  }

  void _onTaskFeedbackCleared(
    TaskFeedbackCleared event,
    Emitter<TaskState> emit,
  ) {
    emit(
      state.copyWith(
        clearError: true,
        clearAction: true,
      ),
    );
  }

  List<Task> _sortTasks(List<Task> tasks) {
    final sorted = [...tasks]
      ..sort((a, b) {
        if (a.completed != b.completed) {
          return a.completed ? 1 : -1;
        }
        final aDue = a.dueDate ?? a.createdAt;
        final bDue = b.dueDate ?? b.createdAt;
        return aDue.compareTo(bDue);
      });
    return sorted;
  }

  String _messageFrom(Object error) {
    if (error is ApiError) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
