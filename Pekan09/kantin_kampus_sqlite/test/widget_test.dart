import 'package:flutter_test/flutter_test.dart';
import 'package:kantin_kampus_sqlite/main.dart';

void main() {
  testWidgets('Kantin Kampus SQLite smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KantinKampusApp());
    expect(find.text('Produk'), findsWidgets);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });
}
