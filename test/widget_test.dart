// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('Krishna Library opens with 27-seat dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('KRISHNA LIBRARY'), findsOneWidget);
    expect(find.text('Good morning, Aarav'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.event_seat_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Exactly 27 fixed seats for focused study.'), findsOneWidget);
    expect(find.text('27 fixed seats • Tap an available seat to request it.'), findsOneWidget);
  });
}
