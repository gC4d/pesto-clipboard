import 'package:flutter/material.dart' hide ShortcutManager;
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'system_tray_manager.dart';
import 'shortcut_manager.dart';
import '../services/clipboard_monitor_service.dart';
import '../services/realtime_sync_service.dart';
import '../viewmodels/clipboard_viewmodel.dart';
import 'locator.dart';

class AppManager {
  static final AppManager _instance = AppManager._internal();
  factory AppManager() => _instance;
  AppManager._internal();
  
  final SystemTrayManager _systemTrayManager = SystemTrayManager();
  final ShortcutManager _shortcutManager = ShortcutManager();
  final ClipboardMonitorService _clipboardMonitor = ClipboardMonitorService();
  final RealtimeSyncService _realtimeSync = RealtimeSyncService();
  
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
      
      // Start clipboard monitoring
      _startClipboardMonitoring();
      
      // Start real-time synchronization
      _startRealtimeSync();
      
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
  
  void _startClipboardMonitoring() {
    try {
      // Get the clipboard view model to update when new items are detected
      final viewModel = locator<ClipboardViewModel>();
      
      // Set callback for when new clipboard items are detected
      _clipboardMonitor.onNewItem = (item) {
        // Refresh the view model to show the new item
        viewModel.refresh();
      };
      
      // Start monitoring
      _clipboardMonitor.startMonitoring();
      
      debugPrint('Clipboard monitoring started');
    } catch (e) {
      debugPrint('Failed to start clipboard monitoring: $e');
    }
  }
  
  void _startRealtimeSync() {
    try {
      // Get the clipboard view model to update when items change
      final viewModel = locator<ClipboardViewModel>();
      
      // Set callback for when clipboard items are updated
      _realtimeSync.onItemsUpdated = (items) {
        // Update the view model with the new items
        // Note: This is a simplified approach - in a real app, you might want to
        // update the view model more efficiently
        viewModel.refresh();
      };
      
      // Set callback for when new items are added
      _realtimeSync.onNewItem = (item) {
        // Refresh the view model to show the new item
        viewModel.refresh();
      };
      
      // Start synchronization
      _realtimeSync.startSync();
      
      debugPrint('Real-time synchronization started');
    } catch (e) {
      debugPrint('Failed to start real-time synchronization: $e');
    }
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
    _clipboardMonitor.dispose();
    _realtimeSync.dispose();
  }
}
