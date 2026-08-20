import 'package:flutter_test/flutter_test.dart';
import 'package:worth_soldier_school/app.dart';

void main() {
  testWidgets('App renders splash screen branding test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SchoolApp());

    // Verify school branding exists on splash screen
    expect(find.text('WORTH RM SOLDIER'), findsOneWidget);
    expect(find.text('PUBLIC SCHOOL'), findsOneWidget);
    expect(find.text('Learn • Grow • Succeed'), findsOneWidget);
  });
}
