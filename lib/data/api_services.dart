import 'package:assignment/core/api_clients.dart';
import 'package:assignment/core/api_constants.dart';
import 'package:assignment/data/models/post_model.dart';
import 'package:assignment/data/models/todo_model.dart';
import 'package:assignment/data/models/user_model.dart';

abstract class ApiService {
  Future<UserResponse> getUsers({int limit = 20, int skip = 0, String? search});
  Future<PostResponse> getUserPosts(int userId);
  Future<TodoResponse> getUserTodos(int userId);
}

class ApiServiceImpl implements ApiService {
  final ApiClient apiClient;

  ApiServiceImpl(this.apiClient);

  @override
  Future<UserResponse> getUsers({
    int limit = 20,
    int skip = 0,
    String? search,
  }) async {
    final url = ApiConstants.getUsersUrl(
      limit: limit,
      skip: skip,
      search: search,
    );
    final response = await apiClient.get(url);
    return UserResponse.fromJson(response);
  }

  @override
  Future<PostResponse> getUserPosts(int userId) async {
    final url = ApiConstants.getUserPostsUrl(userId);
    final response = await apiClient.get(url);
    return PostResponse.fromJson(response);
  }

  @override
  Future<TodoResponse> getUserTodos(int userId) async {
    final url = ApiConstants.getUserTodosUrl(userId);
    final response = await apiClient.get(url);
    return TodoResponse.fromJson(response);
  }
}
