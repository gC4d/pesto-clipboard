import 'dart:io';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class SystemTrayManager {
  static final SystemTrayManager _instance = SystemTrayManager._internal();
  factory SystemTrayManager() => _instance;
  SystemTrayManager._internal();
  
  final SystemTray _systemTray = SystemTray();
  
  bool _isInitialized = false;
  
  Future<void> initSystemTray() async {
    if (_isInitialized) return;
    
    try {
      // Initialize system tray
      await _systemTray.initSystemTray(
        title: "Pesto Clipboard",
        iconPath: Platform.isWindows 
            ? "assets/icons/app_icon.ico" 
            : "assets/icons/app_icon.png",
      );
      
      // Create context menu
      final Menu menu = Menu();
      await menu.buildFrom([
        MenuItemLabel(
          label: 'Show',
          onClicked: (menuItem) => showWindow(),
        ),
        MenuItemLabel(
          label: 'Exit',
          onClicked: (menuItem) => exit(0),
        ),
      ]);
      
      // Set context menu
      await _systemTray.setContextMenu(menu);
      
      // Set tray icon click listener
      _systemTray.registerSystemTrayEventHandler((eventName) {
        if (eventName == "leftMouseDown") {
          showWindow();
        }
      });
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize system tray: $e');
    }
  }
  
  void showWindow() {
    appWindow.show();
    _isWindowVisible = true;
  }
  
  void hideWindow() {
    appWindow.hide();
    _isWindowVisible = false;
  }
  
  // Global variable to track window visibility
  bool _isWindowVisible = false;
  
  void toggleWindow() {
    if (_isWindowVisible) {
      debugPrint('Hiding window');
      hideWindow();
    } else {
      debugPrint('Showing window');
      showWindow();
    }
  }
  
  Future<void> dispose() async {
    await _systemTray.destroy();
  }
}
