import 'package:get_it/get_it.dart';
import 'package:to_do_app/core/api/dio_client.dart';
import 'package:to_do_app/core/api/token_manager.dart';
import 'package:to_do_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:to_do_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:to_do_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:to_do_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:to_do_app/features/auth/domain/usecases/restore_session.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_out.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:to_do_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:to_do_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:to_do_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:to_do_app/features/tasks/domain/usecases/create_task.dart';
import 'package:to_do_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:to_do_app/features/tasks/domain/usecases/load_tasks.dart';
import 'package:to_do_app/features/tasks/domain/usecases/toggle_task_completion.dart';
import 'package:to_do_app/features/tasks/domain/usecases/update_task.dart';
import 'package:to_do_app/features/tasks/presentation/bloc/task_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  if (getIt.isRegistered<AuthBloc>()) {
    return;
  }

  getIt
    ..registerLazySingleton<DioClient>(DioClient.new)
    ..registerLazySingleton<TokenManager>(TokenManager.new)
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSource(getIt()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    )
    ..registerLazySingleton<RestoreSession>(() => RestoreSession(getIt()))
    ..registerLazySingleton<SignInWithEmail>(() => SignInWithEmail(getIt()))
    ..registerLazySingleton<SignUpWithEmail>(() => SignUpWithEmail(getIt()))
    ..registerLazySingleton<SignOut>(() => SignOut(getIt()))
    ..registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(getIt()))
    ..registerLazySingleton<LoadTasks>(() => LoadTasks(getIt()))
    ..registerLazySingleton<CreateTask>(() => CreateTask(getIt()))
    ..registerLazySingleton<UpdateTask>(() => UpdateTask(getIt()))
    ..registerLazySingleton<DeleteTask>(() => DeleteTask(getIt()))
    ..registerLazySingleton<ToggleTaskCompletion>(
      () => ToggleTaskCompletion(getIt()),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        restoreSession: getIt(),
        signInWithEmail: getIt(),
        signUpWithEmail: getIt(),
        signOut: getIt(),
      ),
    )
    ..registerFactory<TaskBloc>(
      () => TaskBloc(
        loadTasks: getIt(),
        createTask: getIt(),
        updateTask: getIt(),
        deleteTask: getIt(),
        toggleTaskCompletion: getIt(),
      ),
    );
}
