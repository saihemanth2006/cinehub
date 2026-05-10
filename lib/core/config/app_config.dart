/// Environment configuration for CineHub.
///
/// Use `--dart-define=ENV=dev` to switch environments at build time.
/// Supports dev (local backend), staging, and production.
enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String geminiApiKey;
  final bool enableAnalytics;
  final bool enableLogging;
  final Duration apiTimeout;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.geminiApiKey,
    required this.enableAnalytics,
    required this.enableLogging,
    required this.apiTimeout,
  });

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (env) {
      case 'prod':
        return AppConfig.prod();
      case 'staging':
        return AppConfig.staging();
      default:
        return AppConfig.dev();
    }
  }

  /// Local development — points to local Node.js backend.
  factory AppConfig.dev() => const AppConfig._(
        environment: Environment.dev,
        apiBaseUrl: 'https://cinehub-qltm.onrender.com',
        geminiApiKey: String.fromEnvironment(
          'GEMINI_KEY',
          defaultValue: '',
        ),
        enableAnalytics: false,
        enableLogging: true,
        apiTimeout: Duration(seconds: 30),
      );

  /// Staging — deployed test backend.
  factory AppConfig.staging() => const AppConfig._(
        environment: Environment.staging,
        apiBaseUrl: 'https://cinehub-qltm.onrender.com',
        geminiApiKey: String.fromEnvironment('GEMINI_KEY', defaultValue: ''),
        enableAnalytics: true,
        enableLogging: true,
        apiTimeout: Duration(seconds: 20),
      );

  /// Production — live backend.
  factory AppConfig.prod() => const AppConfig._(
        environment: Environment.prod,
        apiBaseUrl: 'https://cinehub-qltm.onrender.com',
        geminiApiKey: String.fromEnvironment('GEMINI_KEY', defaultValue: ''),
        enableAnalytics: true,
        enableLogging: false,
        apiTimeout: Duration(seconds: 15),
      );

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;
  bool get isStaging => environment == Environment.staging;
}
