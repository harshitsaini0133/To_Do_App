import 'package:to_do_app/core/api/api_error.dart';
import 'package:to_do_app/core/api/api_routes.dart';
import 'package:to_do_app/core/api/base_remote_source.dart';
import 'package:to_do_app/core/config/app_config.dart';
import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/tasks/data/models/task_model.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';

class TasksRemoteDataSource extends BaseRemoteSource {
  const TasksRemoteDataSource(super.client);

  Future<List<TaskModel>> fetchTasks(AuthSession session) {
    _ensureConfigured();
    return guard(
      request: () => client.getUri(
        ApiRoutes.userTasks(session.localId, authToken: session.idToken),
      ),
      parser: (json) {
        if (json == null) {
          return <TaskModel>[];
        }

        final rawMap = Map<String, dynamic>.from(json as Map);
        final tasks = rawMap.entries
            .map(
              (entry) => TaskModel.fromFirebaseJson(
                entry.key,
                Map<String, dynamic>.from(entry.value as Map),
              ),
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return tasks;
      },
    );
  }

  Future<TaskModel> createTask(AuthSession session, TaskDraft draft) async {
    _ensureConfigured();
    final createdAt = DateTime.now();
    final createdTaskId = await guard<String>(
      request: () => client.postUri(
        ApiRoutes.userTasks(session.localId, authToken: session.idToken),
        data: TaskModel.createPayload(draft, createdAt),
      ),
      parser: (json) => (json as Map<String, dynamic>)['name'] as String,
    );

    return TaskModel(
      id: createdTaskId,
      title: draft.title.trim(),
      description: draft.description?.trim().isEmpty ?? true
          ? null
          : draft.description?.trim(),
      dueDate: draft.dueDate,
      createdAt: createdAt,
      completed: false,
    );
  }

  Future<TaskModel> updateTask(AuthSession session, Task task) async {
    _ensureConfigured();
    final model = TaskModel.fromEntity(task);
    await guard<void>(
      request: () => client.patchUri(
        ApiRoutes.taskById(
          session.localId,
          task.id,
          authToken: session.idToken,
        ),
        data: model.toFirebaseJson(),
      ),
      parser: (_) {},
    );
    return model;
  }

  Future<void> deleteTask(AuthSession session, String taskId) {
    _ensureConfigured();
    return guard<void>(
      request: () => client.deleteUri(
        ApiRoutes.taskById(
          session.localId,
          taskId,
          authToken: session.idToken,
        ),
      ),
      parser: (_) {},
    );
  }

  void _ensureConfigured() {
    if (!AppConfig.isFirebaseConfigured) {
      throw const ApiError(
        message:
            'Firebase is not configured. Add FIREBASE_API_KEY and FIREBASE_DATABASE_URL.',
        type: ApiErrorType.validation,
      );
    }
  }
}
