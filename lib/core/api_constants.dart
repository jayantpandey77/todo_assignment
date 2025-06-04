class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String users = '/users';
  static const String posts = '/posts';
  static const String todos = '/todos';

  // Pagination
  static const int defaultLimit = 20;
  static const int searchLimit = 10;

  // Endpoints
  static String getUsersUrl({
    int limit = defaultLimit,
    int skip = 0,
    String? search,
  }) {
    var url = '$baseUrl$users?limit=$limit&skip=$skip';
    if (search != null && search.isNotEmpty) {
      url += '&q=$search';
    }
    return url;
  }

  static String getUserPostsUrl(int userId) => '$baseUrl$posts/user/$userId';
  static String getUserTodosUrl(int userId) => '$baseUrl$todos/user/$userId';
}
