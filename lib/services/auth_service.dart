import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();

  // Social actions
  Future<bool> follow(String toId) async {
    try {
      final resp = await _apiClient.post('/api/follow', data: {'to': toId});
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unfollow(String toId) async {
    try {
      final resp = await _apiClient.post('/api/unfollow', data: {'to': toId});
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> likePost(String postId) async {
    try {
      final resp = await _apiClient.post('/api/posts/$postId/like');
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      final resp = await _apiClient.delete('/api/posts/$postId/like');
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Fetch feed posts from backend. Returns list of post maps or empty list.
  Future<List<Map<String, dynamic>>> fetchFeed({int page = 1, int limit = 20}) async {
    try {
      final resp = await _apiClient.get('/api/feed?page=$page&limit=$limit');
      if (resp.statusCode == 200) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) {
          final list = parsed['posts'];
          if (list is List) {
            return List<Map<String, dynamic>>.from(list.map((e) {
              if (e is Map) return Map<String, dynamic>.from(e.cast<String, dynamic>());
              return <String, dynamic>{};
            }));
          }
        }
      }
    } catch (_) {}
    return <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>?> fetchUserStats(String userId) async {
    if (userId.isEmpty) return null;
    try {
      final resp = await _apiClient.get('/api/users/$userId/stats');
      if (resp.statusCode == 200) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) return parsed as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchFollowers(String userId) async {
    try {
      final resp = await _apiClient.get('/api/users/$userId/followers');
      if (resp.statusCode == 200) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) {
          final list = parsed['followers'] as List?;
          return list != null ? List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e))) : <Map<String,dynamic>>[];
        }
      }
    } catch (_) {}
    return <Map<String,dynamic>>[];
  }

  /// Fetch all users (basic public info)
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final resp = await _apiClient.get('/api/users');
      if (resp.statusCode == 200) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) {
          final list = parsed['users'] as List?;
          return list != null ? List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e))) : <Map<String,dynamic>>[];
        }
      }
    } catch (_) {}
    return <Map<String,dynamic>>[];
  }

  Future<List<Map<String, dynamic>>> fetchFollowing(String userId) async {
    try {
      final resp = await _apiClient.get('/api/users/$userId/following');
      if (resp.statusCode == 200) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) {
          final list = parsed['following'] as List?;
          return list != null ? List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e))) : <Map<String,dynamic>>[];
        }
      }
    } catch (_) {}
    return <Map<String,dynamic>>[];
  }

  /// Create a new post. Returns parsed post map on success, otherwise null.
  Future<Map<String, dynamic>?> createPost(String content, {List<String>? media}) async {
    try {
      final body = {'content': content, 'media': media ?? []};
      final resp = await _apiClient.post('/api/posts', data: body);
      
      if (resp.statusCode != null && resp.statusCode! >= 200 && resp.statusCode! < 300) {
        final parsed = resp.data;
        if (parsed is Map && parsed['ok'] == true) return parsed['post'] as Map<String, dynamic>?;
        throw ApiException(parsed is Map && parsed['error'] != null ? parsed['error'].toString() : 'unknown_response');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
