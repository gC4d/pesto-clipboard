import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/clipboard_list_screen.dart';
import 'services/clipboard_provider.dart';
import 'services/clipboard_service.dart';
import 'services/clipboard_monitor.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'utils/app_theme.dart';

// Global navigator key for accessing context from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create the services
  final notificationService = NotificationService();
  final apiService = ApiService();
  final clipboardService = ClipboardService(apiService: apiService);
  
  // Create monitor with direct reference to the service
  final clipboardMonitor = ClipboardMonitor(clipboardService: clipboardService);
  
  // Start monitoring clipboard changes
  clipboardMonitor.startMonitoring();
  
  runApp(PestoClipboardApp(
    notificationService: notificationService,
    clipboardService: clipboardService,
    clipboardMonitor: clipboardMonitor,
  ));
}

class PestoClipboardApp extends StatelessWidget {
  final NotificationService notificationService;
  final ClipboardService clipboardService;
  final ClipboardMonitor clipboardMonitor;
  
  const PestoClipboardApp({
    super.key, 
    required this.notificationService,
    required this.clipboardService,
    required this.clipboardMonitor,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the notification service
        Provider<NotificationService>.value(value: notificationService),
        
        // Provide the clipboard service
        Provider<ClipboardService>.value(value: clipboardService),
        
        // Provide the clipboard monitor
        Provider<ClipboardMonitor>.value(value: clipboardMonitor),
        
        // Create the clipboard provider with the clipboard service
        ChangeNotifierProxyProvider<ClipboardService, ClipboardProvider>(
          create: (context) => ClipboardProvider(),
          update: (context, clipboardService, previousProvider) {
            // Create or reuse provider
            final provider = previousProvider ?? ClipboardProvider(clipboardService: clipboardService);
            
            // Register the provider with the clipboard monitor
            // This allows direct updates when clipboard changes
            Future.microtask(() {
              clipboardMonitor.registerProvider(provider);
              print('MAIN: Registered provider with clipboard monitor');
            });
            
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Pesto Clipboard',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system, // Use system theme by default
        scaffoldMessengerKey: notificationService.scaffoldMessengerKey,
        home: const ClipboardListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
