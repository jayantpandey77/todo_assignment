import 'dart:convert';
import 'package:assignment/core/exceptions.dart';
import 'package:assignment/data/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<Post>> getUserPosts(int userId);
  Future<Post> createPost(Post post);
  Future<List<Post>> getLocalPosts(int userId);
  Future<void> saveLocalPost(Post post);
}

class PostRepositoryImpl implements PostRepository {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  static const String localPostsKey = 'LOCAL_POSTS';

  PostRepositoryImpl(this.apiService, this.sharedPreferences);

  @override
  Future<List<Post>> getUserPosts(int userId) async {
    try {
      final response = await apiService.getUserPosts(userId);
      final localPosts = await getLocalPosts(userId);

      // Combine API posts with local posts
      final allPosts = [...localPosts, ...response.posts];
      allPosts.sort((a, b) => b.id.compareTo(a.id));

      return allPosts;
    } catch (e) {
      // If network fails, return only local posts
      return await getLocalPosts(userId);
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    await saveLocalPost(post);
    return post;
  }

  @override
  Future<List<Post>> getLocalPosts(int userId) async {
    try {
      final jsonString = sharedPreferences.getString(localPostsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final allPosts = jsonList.map((json) => Post.fromJson(json)).toList();
        return allPosts.where((post) => post.userId == userId).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get local posts');
    }
  }

  @override
  Future<void> saveLocalPost(Post post) async {
    try {
      final existingPosts = await _getAllLocalPosts();
      existingPosts.add(post);

      final jsonString = jsonEncode(
        existingPosts.map((p) => p.toJson()).toList(),
      );
      await sharedPreferences.setString(localPostsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save local post');
    }
  }

  Future<List<Post>> _getAllLocalPosts() async {
    try {
      final jsonString = sharedPreferences.getString(localPostsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
