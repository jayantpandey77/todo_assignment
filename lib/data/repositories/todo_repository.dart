import 'package:assignment/data/api_services.dart';

import '../models/todo_model.dart';

abstract class TodoRepository {
  Future<List<Todo>> getUserTodos(int userId);
}

class TodoRepositoryImpl implements TodoRepository {
  final ApiService apiService;

  TodoRepositoryImpl(this.apiService);

  @override
  Future<List<Todo>> getUserTodos(int userId) async {
    final response = await apiService.getUserTodos(userId);
    return response.todos;
  }
}
