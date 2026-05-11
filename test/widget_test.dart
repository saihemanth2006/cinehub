import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cinehubapp/app.dart';
import 'package:cinehubapp/features/auth/auth_provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the app and ensure it renders a MaterialApp
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const CineHubApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
