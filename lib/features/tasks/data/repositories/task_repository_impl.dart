import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this.remoteDataSource);

  final TasksRemoteDataSource remoteDataSource;

  @override
  Future<List<Task>> fetchTasks(AuthSession session) {
    return remoteDataSource.fetchTasks(session);
  }

  @override
  Future<Task> createTask(AuthSession session, TaskDraft draft) {
    return remoteDataSource.createTask(session, draft);
  }

  @override
  Future<Task> updateTask(AuthSession session, Task task) {
    return remoteDataSource.updateTask(session, task);
  }

  @override
  Future<void> deleteTask(AuthSession session, String taskId) {
    return remoteDataSource.deleteTask(session, taskId);
  }
}
