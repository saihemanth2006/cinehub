# CineHub — Frontend-Backend Integration Guide

## 📋 Overview

This document provides complete instructions for connecting the Flutter frontend to the Node.js/Express backend, including API configuration, state management, error handling, and real-time features.

---

## 🏗️ Architecture

### Communication Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Frontend                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Riverpod State Management                           │  │
│  │  ├─ authProvider (login state)                      │  │
│  │  ├─ userProvider (current user)                     │  │
│  │  ├─ projectsProvider (user projects)                │  │
│  │  └─ aiProvider (AI generation states)               │  │
│  └──────────────────────────────────────────────────────┘  │
│           ↓ (HTTP/REST API Calls)                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  HTTP Client (dio/http package)                     │  │
│  │  ├─ Authorization headers with JWT token            │  │
│  │  ├─ Request/response interceptors                   │  │
│  │  └─ Error handling & retry logic                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
           ↓↓↓ (HTTP/HTTPS)
           ↓↓↓
┌─────────────────────────────────────────────────────────────┐
│                  Node.js/Express Backend                    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Express Middleware Stack                           │  │
│  │  ├─ CORS validation                                │  │
│  │  ├─ Request logging                                 │  │
│  │  ├─ JSON parsing                                    │  │
│  │  ├─ Rate limiting                                   │  │
│  │  └─ Authentication (JWT)                            │  │
│  └──────────────────────────────────────────────────────┘  │
│           ↓                                                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  API Routes & Controllers                           │  │
│  │  ├─ /auth (login, register, refresh)               │  │
│  │  ├─ /users (profile, search)                        │  │
│  │  ├─ /projects (CRUD)                                │  │
│  │  ├─ /ai/generate (AI features)                      │  │
│  │  └─ /discovery (creator search)                     │  │
│  └──────────────────────────────────────────────────────┘  │
│           ↓                                                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Services & Business Logic                          │  │
│  │  ├─ AuthService (JWT, password hashing)            │  │
│  │  ├─ AIService (Gemini/OpenAI orchestration)        │  │
│  │  ├─ UserService (profile management)                │  │
│  │  └─ ProjectService (CRUD & validation)              │  │
│  └──────────────────────────────────────────────────────┘  │
│           ↓                                                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Data Layer                                         │  │
│  │  ├─ MongoDB (primary data store)                   │  │
│  │  ├─ Redis (caching & sessions)                      │  │
│  │  └─ Repositories (abstraction layer)                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔌 API Configuration in Flutter

### Step 1: Create HTTP Client Service

Create `lib/core/network/http_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehub/core/config/app_config.dart';
import 'package:cinehub/core/error/api_exception.dart';

class HttpClient {
  final Dio _dio;

  HttpClient({required String baseUrl, required String token})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        ) {
    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle 401 - refresh token
          if (error.response?.statusCode == 401) {
            // Trigger token refresh
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> patch<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> delete<T>(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

// Provider
final httpClientProvider = Provider<HttpClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final token = ref.watch(accessTokenProvider);

  return HttpClient(
    baseUrl: config.apiBaseUrl,
    token: token ?? '',
  );
});
```

### Step 2: Configure API Base URL

Update `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Development
  static const String apiBaseUrlDev = 'http://localhost:5000/api/v1';

  // Production
  static const String apiBaseUrlProd = 'https://api.cinehub.com/api/v1';

  String get apiBaseUrl => isProduction ? apiBaseUrlProd : apiBaseUrlDev;

  // Or use environment variable
  String get apiBaseUrl => String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api/v1',
  );
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});
```

---

## 🔐 Authentication Integration

### Step 1: Create Auth API Service

Create `lib/features/auth/data/datasources/auth_remote_datasource.dart`:

```dart
import 'package:cinehub/core/network/http_client.dart';
import 'package:cinehub/features/auth/data/models/auth_response.dart';

class AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSource(this.httpClient);

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await httpClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );

    return AuthResponse.fromJson(response);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await httpClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(response);
  }

  Future<AuthResponse> refreshTokens(String refreshToken) async {
    final response = await httpClient.post<Map<String, dynamic>>(
      '/auth/refresh-tokens',
      data: {'refreshToken': refreshToken},
    );

    return AuthResponse.fromJson(response);
  }

  Future<void> logout() async {
    await httpClient.post('/auth/logout');
  }
}
```

### Step 2: Create Auth Model

Create `lib/features/auth/data/models/auth_response.dart`:

```dart
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['data']['tokens']['accessToken'] ?? '',
      refreshToken: json['data']['tokens']['refreshToken'] ?? '',
      user: UserData.fromJson(json['data']['user']),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String? bio;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.bio,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
    );
  }
}
```

### Step 3: Create Auth Provider

Create `lib/features/auth/presentation/providers/auth_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehub/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cinehub/core/network/http_client.dart';

// Token providers
final accessTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);

// Auth state
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) {
    final httpClient = ref.watch(httpClientProvider);
    final dataSource = AuthRemoteDataSource(httpClient);
    return AuthNotifier(dataSource, ref);
  },
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRemoteDataSource dataSource;
  final Ref ref;

  AuthNotifier(this.dataSource, this.ref) : super(const AsyncValue.data(null));

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await dataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      ref.read(accessTokenProvider.notifier).state = response.accessToken;
      ref.read(refreshTokenProvider.notifier).state = response.refreshToken;

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await dataSource.login(
        email: email,
        password: password,
      );

      ref.read(accessTokenProvider.notifier).state = response.accessToken;
      ref.read(refreshTokenProvider.notifier).state = response.refreshToken;

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    try {
      await dataSource.logout();

      ref.read(accessTokenProvider.notifier).state = null;
      ref.read(refreshTokenProvider.notifier).state = null;

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
```

---

## 🤖 AI Generation Integration

### Create AI API Service

Create `lib/features/ai/data/datasources/ai_remote_datasource.dart`:

```dart
import 'package:cinehub/core/network/http_client.dart';

class AIRemoteDataSource {
  final HttpClient httpClient;

  AIRemoteDataSource(this.httpClient);

  Future<Map<String, dynamic>> generate({
    required String module,
    required String task,
    required dynamic input,
    Map<String, dynamic>? options,
  }) async {
    final response = await httpClient.post<Map<String, dynamic>>(
      '/ai/generate',
      data: {
        'module': module,
        'task': task,
        'input': input,
        'options': options ?? {},
      },
    );

    return response;
  }

  Future<List<dynamic>> getCapabilities() async {
    return await httpClient.get<List<dynamic>>('/ai/capabilities');
  }

  Future<List<dynamic>> getModules() async {
    return await httpClient.get<List<dynamic>>('/ai/modules');
  }
}
```

### Create AI Provider

Create `lib/features/ai/presentation/providers/ai_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehub/core/network/http_client.dart';
import 'package:cinehub/features/ai/data/datasources/ai_remote_datasource.dart';

final aiRemoteDataSourceProvider = Provider<AIRemoteDataSource>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return AIRemoteDataSource(httpClient);
});

final aiGenerateProvider = FutureProvider.family<
  Map<String, dynamic>,
  AIGenerateParams
>(
  (ref, params) async {
    final dataSource = ref.watch(aiRemoteDataSourceProvider);
    return dataSource.generate(
      module: params.module,
      task: params.task,
      input: params.input,
      options: params.options,
    );
  },
);

class AIGenerateParams {
  final String module;
  final String task;
  final dynamic input;
  final Map<String, dynamic>? options;

  AIGenerateParams({
    required this.module,
    required this.task,
    required this.input,
    this.options,
  });
}
```

---

## 🗂️ Projects Integration

### Create Project API Service

Create `lib/features/projects/data/datasources/project_remote_datasource.dart`:

```dart
import 'package:cinehub/core/network/http_client.dart';

class ProjectRemoteDataSource {
  final HttpClient httpClient;

  ProjectRemoteDataSource(this.httpClient);

  Future<List<dynamic>> getProjects() async {
    final response = await httpClient.get<Map<String, dynamic>>(
      '/projects',
    );
    return response['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createProject({
    required String title,
    required String description,
    required String genre,
  }) async {
    final response = await httpClient.post<Map<String, dynamic>>(
      '/projects',
      data: {
        'title': title,
        'description': description,
        'genre': genre,
      },
    );
    return response['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProject(
    String projectId, {
    String? title,
    String? description,
    String? status,
    int? progress,
  }) async {
    final response = await httpClient.patch<Map<String, dynamic>>(
      '/projects/$projectId',
      data: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
        if (progress != null) 'progress': progress,
      },
    );
    return response['data'] as Map<String, dynamic>;
  }

  Future<void> deleteProject(String projectId) async {
    await httpClient.delete('/projects/$projectId');
  }
}
```

---

## 💬 Real-Time Messaging (Socket.IO)

### Create Socket Service

Create `lib/core/network/socket_client.dart`:

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocketClient {
  final IO.Socket socket;

  SocketClient({
    required String url,
    required String token,
  }) : socket = IO.io(
    url,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth({'token': token})
        .build(),
  ) {
    _setupListeners();
  }

  void _setupListeners() {
    socket.on('connect', (_) {
      print('✓ Socket connected');
    });

    socket.on('disconnect', (_) {
      print('✗ Socket disconnected');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });

    // Custom events
    socket.on('message:new', (data) {
      print('New message: $data');
    });

    socket.on('notification:new', (data) {
      print('New notification: $data');
    });
  }

  void connect() {
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function callback) {
    socket.on(event, callback);
  }
}

final socketClientProvider = Provider<SocketClient>((ref) {
  final token = ref.watch(accessTokenProvider) ?? '';

  return SocketClient(
    url: 'http://localhost:5000',
    token: token,
  );
});
```

---

## 🧪 Testing the Integration

### 1. Test Authentication Flow

```dart
// In your auth screen
ElevatedButton(
  onPressed: () async {
    ref.read(authStateProvider.notifier).login(
      email: 'test@cinehub.ai',
      password: 'TestPass123!',
    );
  },
  child: const Text('Login'),
),
```

### 2. Test AI Generation

```dart
// In your AI screen
ElevatedButton(
  onPressed: () async {
    ref.refresh(aiGenerateProvider(
      AIGenerateParams(
        module: 'script-development',
        task: 'story-expansion',
        input: 'A detective solving cyber crimes in 2050',
        options: {'genre': 'sci-fi noir'},
      ),
    ));
  },
  child: const Text('Generate Story'),
),
```

### 3. Test Project CRUD

```dart
// Create project
final projectResponse = await dataSource.createProject(
  title: 'My First Film',
  description: 'A short indie film',
  genre: 'drama',
);
```

---

## 🔗 Common API Response Format

All backend endpoints return this format:

```json
{
  "status": "success",
  "message": "Operation successful",
  "data": {
    // Response data here
  },
  "meta": {
    "timestamp": "2024-05-08T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

---

## ⚠️ Error Handling

### API Exception Class

Create `lib/core/error/api_exception.dart`:

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  factory ApiException.fromDioException(DioException e) {
    String message = 'An error occurred';

    if (e.response != null) {
      message = e.response?.data['message'] ?? 'Request failed';

      if (e.response?.statusCode == 401) {
        message = 'Unauthorized - please login again';
      } else if (e.response?.statusCode == 403) {
        message = 'Forbidden - you do not have permission';
      } else if (e.response?.statusCode == 404) {
        message = 'Not found - resource does not exist';
      } else if (e.response?.statusCode == 429) {
        message = 'Too many requests - please try again later';
      }
    }

    return ApiException(
      message: message,
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }

  @override
  String toString() => message;
}
```

---

## 📚 Complete Endpoint Reference

### Authentication Endpoints

- `POST /auth/register` - Register new user
- `POST /auth/login` - Login with credentials
- `POST /auth/refresh-tokens` - Refresh access token
- `POST /auth/logout` - Logout user
- `GET /auth/me` - Get current user profile

### User Endpoints

- `GET /users` - List all users
- `GET /users/{id}` - Get user profile
- `PATCH /users/{id}` - Update user profile
- `GET /discovery/creators` - Search creators

### Project Endpoints

- `GET /projects` - List user projects
- `POST /projects` - Create project
- `GET /projects/{id}` - Get project
- `PATCH /projects/{id}` - Update project
- `DELETE /projects/{id}` - Delete project

### AI Endpoints

- `POST /ai/test-generate` - Test AI (no auth)
- `POST /ai/generate` - Generate with AI
- `GET /ai/capabilities` - List AI capabilities
- `GET /ai/modules` - List AI modules

### Media Endpoints

- `POST /media/upload` - Upload image
- `POST /media/upload/video` - Upload video

---

## 🚀 Deployment

### Update API URL for Production

```dart
class AppConfig {
  // Use environment-specific URLs
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api/v1', // dev
  );

  // Or use build flavor
  static const String apiBaseUrl = 'https://api.cinehub.com/api/v1';
}
```

### Building for Production

```bash
# iOS
flutter build ios --dart-define=API_BASE_URL=https://api.cinehub.com/api/v1

# Android
flutter build apk --dart-define=API_BASE_URL=https://api.cinehub.com/api/v1

# Web
flutter build web --dart-define=API_BASE_URL=https://api.cinehub.com/api/v1
```

---

## 📞 Troubleshooting

### Connection Refused

```
Error: Connection refused (http://localhost:5000)
```

**Solution:**

- Check backend is running: `npm run dev`
- Verify port 5000 is not blocked
- Check `CLIENT_URL` matches Flutter app URL

### 401 Unauthorized

```
Error: Unauthorized - Token invalid or expired
```

**Solution:**

- Ensure token is in `Authorization: Bearer {token}` format
- Implement token refresh in HTTP interceptor
- Check JWT secrets in `.env`

### CORS Error

```
Error: Access to XMLHttpRequest blocked by CORS policy
```

**Solution:**

- Verify `CLIENT_URL` in backend `.env` matches frontend URL
- Check CORS headers in Express middleware
- Restart backend after `.env` changes

---

**Status**: ✅ Complete
**Version**: 1.0.0
**Last Updated**: May 8, 2024
