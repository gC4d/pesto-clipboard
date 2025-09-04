import 'package:flutter/material.dart';
import 'package:frontend/screens/clipboard_list_screen.dart';
import 'utils/app_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'utils/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  setupLocator();
  
  runApp(PestoClipboardApp());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(50, 100);
    appWindow.size = const Size(400, 500);
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class PestoClipboardApp extends StatelessWidget {
  const PestoClipboardApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pesto Clipboard',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system, // Use system theme by default
        home: const ClipboardListScreen(),
        debugShowCheckedModeBanner: false,
    );
  }
}
