import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:frontend/utils/system_tray_manager.dart';

class ShortcutManager {
  static final ShortcutManager _instance = ShortcutManager._internal();
  factory ShortcutManager() => _instance;
  ShortcutManager._internal();
  
  final HotKeyManager _hotKeyManager = HotKeyManager.instance;
  final SystemTrayManager _systemTrayManager = SystemTrayManager();
  
  bool _isInitialized = false;
  
  Future<void> initShortcuts() async {
    if (_isInitialized) return;
    
    // Initialize hotkey manager
    await _hotKeyManager.unregisterAll();
    
    // Use only F12 as the shortcut
    final hotKey = HotKey(
      key: LogicalKeyboardKey.f12,
      modifiers: [], // No modifiers needed
      scope: HotKeyScope.system,
    );
    
    try {
      debugPrint('Attempting to register: F12');
      
      await _hotKeyManager.register(
        hotKey,
        keyDownHandler: (hotKey) {
          debugPrint('F12 shortcut pressed');
          _systemTrayManager.toggleWindow();
        },
      );
      
      debugPrint('F12 shortcut registered successfully');
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to register F12 shortcut: $e');
      debugPrint('App will only be accessible via system tray.');
      _isInitialized = true; // Still mark as initialized so app can continue
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
    await _hotKeyManager.unregisterAll();
  }
}