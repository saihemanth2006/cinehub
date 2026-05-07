import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/theme.dart';
import 'core/router/app_router.dart';

/// CineHub MaterialApp with GoRouter, dark cinematic theme,
/// and DevicePreview integration for development.
///
/// Android-only app — no platform checks needed.
class CineHubApp extends StatelessWidget {
  final Locale? locale;

  const CineHubApp({super.key, this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: buildCineHubTheme(),
      darkTheme: buildCineHubTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      // DevicePreview integration
      locale: locale,
      builder: (context, child) {
        // Chain DevicePreview builder with MediaQuery text scale clamping
        // to prevent extreme font sizes on accessibility-heavy devices
        final wrappedChild = DevicePreview.appBuilder(context, child);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.4),
            ),
          ),
          child: wrappedChild,
        );
      },
    );
  }
}
