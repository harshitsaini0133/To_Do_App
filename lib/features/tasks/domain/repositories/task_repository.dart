import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(AuthSession session);
  Future<Task> createTask(AuthSession session, TaskDraft draft);
  Future<Task> updateTask(AuthSession session, Task task);
  Future<void> deleteTask(AuthSession session, String taskId);
}
