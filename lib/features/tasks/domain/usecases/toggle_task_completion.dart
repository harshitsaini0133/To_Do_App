import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';

class ToggleTaskCompletion {
  const ToggleTaskCompletion(this.repository);

  final TaskRepository repository;

  Future<Task> call(AuthSession session, Task task) {
    return repository.updateTask(
      session,
      task.copyWith(completed: !task.completed),
    );
  }
}
