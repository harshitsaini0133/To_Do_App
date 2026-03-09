import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';

class LoadTasks {
  const LoadTasks(this.repository);

  final TaskRepository repository;

  Future<List<Task>> call(AuthSession session) {
    return repository.fetchTasks(session);
  }
}
