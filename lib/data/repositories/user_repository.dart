import 'dart:convert';
import 'package:assignment/core/exceptions.dart';
import 'package:assignment/data/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserResponse> getUsers({int limit = 20, int skip = 0, String? search});
  Future<List<User>> getCachedUsers();
  Future<void> cacheUsers(List<User> users);
}

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  static const String cachedUsersKey = 'CACHED_USERS';

  UserRepositoryImpl(this.apiService, this.sharedPreferences);

  @override
  Future<UserResponse> getUsers({
    int limit = 20,
    int skip = 0,
    String? search,
  }) async {
    try {
      final response = await apiService.getUsers(
        limit: limit,
        skip: skip,
        search: search,
      );

      // Cache users if it's the first page and no search
      if (skip == 0 && (search == null || search.isEmpty)) {
        await cacheUsers(response.users);
      }

      return response;
    } catch (e) {
      // If network fails, try to return cached data
      if (skip == 0 && (search == null || search.isEmpty)) {
        final cachedUsers = await getCachedUsers();
        if (cachedUsers.isNotEmpty) {
          return UserResponse(
            users: cachedUsers.take(limit).toList(),
            total: cachedUsers.length,
            skip: 0,
            limit: limit,
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<User>> getCachedUsers() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUsersKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached users');
    }
  }

  @override
  Future<void> cacheUsers(List<User> users) async {
    try {
      final jsonString = jsonEncode(
        users.map((user) => user.toJson()).toList(),
      );
      await sharedPreferences.setString(cachedUsersKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache users');
    }
  }
}
