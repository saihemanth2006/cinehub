import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/device/device_preview_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode — CineHub is designed as a portrait-first Android app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Force dark status bar and nav bar for cinematic UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111118),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge on Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final config = AppConfig.fromEnvironment();

  runApp(
    DevicePreview(
      // Only enable device preview in development builds
      enabled: false,
      // Android-only device list
      devices: DevicePreviewConfig.androidDevices,
      // Default to Samsung Galaxy S20 (standard flagship)
      defaultDevice: DevicePreviewConfig.defaultDevice,
      // Custom background matching CineHub dark theme
      backgroundColor: const Color(0xFF08080D),
      // Persist device selection across hot restarts
      isToolbarVisible: false,
      builder: (context) => ProviderScope(
        child: CineHubApp(locale: DevicePreview.locale(context)),
      ),
    ),
  );
}
