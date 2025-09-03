// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/clipboard_monitor.dart';
import 'package:frontend/services/clipboard_service.dart';
import 'package:frontend/services/notification_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final notificationService = NotificationService();
    final apiService = ApiService();
    final clipboardService = ClipboardService(apiService: apiService);
    final clipboardMonitor = ClipboardMonitor(clipboardService: clipboardService);
    
    await tester.pumpWidget(PestoClipboardApp(
      notificationService: notificationService,
      clipboardService: clipboardService,
      clipboardMonitor: clipboardMonitor,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
