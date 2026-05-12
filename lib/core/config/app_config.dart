import 'dart:io' show Platform;

/// Simple environment-aware configuration helper.
/// Use `--dart-define=API_BASE_URL=https://api.example.com` when running
/// to override the default development URL.
class AppConfig {
  static String get apiBaseUrl {
    const env = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (env.isNotEmpty) return env;
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:4000';
    } catch (_) {}
    return 'http://localhost:4000';
  }
}
