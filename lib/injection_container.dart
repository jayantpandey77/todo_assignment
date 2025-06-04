import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:assignment/core/api_clients.dart';

// Data
import 'package:assignment/data/api_services.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/post_repository.dart';
import 'data/repositories/todo_repository.dart';

// Presentation
import 'package:assignment/presentation/blocs/post/bloc.dart';
import 'package:assignment/presentation/blocs/theme/bloc.dart';
import 'package:assignment/presentation/blocs/todo/bloc.dart';
import 'package:assignment/presentation/blocs/user/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Data layer
  sl.registerLazySingleton<ApiService>(() => ApiServiceImpl(sl()));

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  // Presentation layer - BLoCs
  sl.registerFactory<UserBloc>(() => UserBloc(sl()));
  sl.registerFactory<PostBloc>(() => PostBloc(sl()));
  sl.registerFactory<TodoBloc>(() => TodoBloc(sl()));

  // Theme Cubit - Singleton to persist theme state
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
}
