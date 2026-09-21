import 'package:flutter_test/flutter_test.dart';
import 'package:kalender_asisten/main.dart';

void main() {
  testWidgets('Kalender Asisten app test', (WidgetTester tester) async {
    await tester.pumpWidget(const KalenderAsistenApp());
  });
}