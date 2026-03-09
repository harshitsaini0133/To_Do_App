import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';

class CreateTask {
  const CreateTask(this.repository);

  final TaskRepository repository;

  Future<Task> call(AuthSession session, TaskDraft draft) {
    return repository.createTask(session, draft);
  }
}
