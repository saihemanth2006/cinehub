import 'package:flutter_test/flutter_test.dart';
import 'package:cinehubapp/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CineHubApp());
    expect(find.text('CineHub'), findsAny);
  });
}
