import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  const DeleteTask(this.repository);

  final TaskRepository repository;

  Future<void> call(AuthSession session, String taskId) {
    return repository.deleteTask(session, taskId);
  }
}
