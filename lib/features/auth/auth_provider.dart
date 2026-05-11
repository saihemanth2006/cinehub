import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userStr = prefs.getString('auth_user');
    if (userStr != null) {
      try {
        _user = jsonDecode(userStr);
      } catch (_) {}
    }
    _isInitialized = true;
    notifyListeners();
    
    // Optionally verify token with backend in the background
    if (_token != null) {
      fetchMe();
    }
  }

  Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    _token = token;
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_user', jsonEncode(user));
    notifyListeners();
  }

  Future<void> clearAuthData() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String identifier, String password) async {
    _setLoading(true);
    try {
      final response = await _apiClient.post('/login', data: {
        'identifier': identifier,
        'password': password,
      });
      
      final data = response.data;
      if (data != null && data['ok'] == true) {
        final token = data['token'];
        final user = data['user'];
        if (token is String && user is Map) {
          await _saveAuthData(token, Map<String, dynamic>.from(user));
        } else {
          throw ApiException('Invalid response format');
        }
      } else {
        throw ApiException(data['error']?.toString() ?? 'Login failed');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await _apiClient.post('/logout');
      }
    } catch (_) {
      // Ignore network errors on logout, we still want to clear local state
    } finally {
      await clearAuthData();
    }
  }

  Future<void> fetchMe() async {
    if (_token == null) return;
    try {
      final response = await _apiClient.get('/me');
      final data = response.data;
      if (data != null && data['ok'] == true) {
        final u = data['user'];
        if (u is Map) {
          _user = Map<String, dynamic>.from(u);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_user', jsonEncode(_user));
          notifyListeners();
        }
      }
    } catch (_) {
      // Background fetch error, maybe token expired?
      // For strict security, we could clear auth data on 401.
    }
  }
}
