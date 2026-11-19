import 'package:flutter_test/flutter_test.dart';
import 'package:aiot_peringatan_dini_sqlite/main.dart';

void main() {
  testWidgets('AIoT Peringatan Dini SQLite smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AiotPeringatanDiniApp());
    expect(find.text('Dashboard Sensor AIoT'), findsOneWidget);
    expect(find.text('Sensor Ketinggian Air Hulu'), findsOneWidget);
  });
}
