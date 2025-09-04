import 'package:flutter/material.dart' hide ShortcutManager;
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'system_tray_manager.dart';
import 'shortcut_manager.dart';

class AppManager {
  static final AppManager _instance = AppManager._internal();
  factory AppManager() => _instance;
  AppManager._internal();
  
  final SystemTrayManager _systemTrayManager = SystemTrayManager();
  final ShortcutManager _shortcutManager = ShortcutManager();
  
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize system tray
      await _systemTrayManager.initSystemTray();
      
      // Initialize shortcuts
      await _shortcutManager.initShortcuts();
      
      // Configure window behavior
      _configureWindow();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize app manager: $e');
    }
  }
  
  void _configureWindow() {
    // Set window properties
    appWindow.minSize = const Size(300, 400);
    appWindow.size = const Size(400, 600);
    appWindow.alignment = Alignment.center;
    
    // Initially hide the window to run in background
    // Uncomment the next line if you want the app to start hidden
    appWindow.hide();
    appWindow.visible = false;
  }
  
  void showWindow() {
    _systemTrayManager.showWindow();
  }
  
  void hideWindow() {
    _systemTrayManager.hideWindow();
  }
  
  void toggleWindow() {
    _systemTrayManager.toggleWindow();
  }
  
  Future<void> dispose() async {
    await _systemTrayManager.dispose();
    await _shortcutManager.dispose();
  }
}
