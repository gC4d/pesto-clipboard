import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/clipboard_item.dart';
import '../config/app_config.dart';
import 'clipboard_service.dart';
import 'clipboard_provider.dart';
import '../main.dart'; // Import for accessing navigatorKey

/// Service that monitors the system clipboard and automatically saves new content
class ClipboardMonitor {
  final ClipboardService _clipboardService;
  Timer? _monitorTimer;
  String? _lastClipboardText;
  ClipboardProvider? _clipboardProvider;
  
  /// Constructor initializes clipboard service
  ClipboardMonitor({required ClipboardService clipboardService}) 
      : _clipboardService = clipboardService;
      
  /// Register a provider to directly update it when clipboard changes
  void registerProvider(ClipboardProvider provider) {
    _clipboardProvider = provider;
    print('CLIPBOARD MONITOR: Provider registered successfully');
  }
  
  /// Start monitoring the clipboard for changes
  void startMonitoring() {
    // Cancel any existing timer
    stopMonitoring();
    
    // Start by capturing the current clipboard content
    _captureCurrentClipboard();
    
    // Start a new timer for regular checking
    _monitorTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.clipboardMonitorInterval),
      (_) => _checkForClipboardChanges(),
    );
  }
  
  /// Stop monitoring the clipboard
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }
  
  /// Capture the initial clipboard state
  Future<void> _captureCurrentClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      _lastClipboardText = clipboardData?.text;
    } catch (e) {
      print('Error capturing initial clipboard: $e');
    }
  }
  
  /// Check for changes in the clipboard content
  Future<void> _checkForClipboardChanges() async {
    try {
      // Get current clipboard text
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final currentText = clipboardData?.text;
      
      // If the clipboard has changed and isn't empty, save it
      if (currentText != null && 
          currentText.isNotEmpty && 
          currentText != _lastClipboardText) {
        
        print('New clipboard content detected: ${currentText.substring(0, currentText.length > 20 ? 20 : currentText.length)}...');
        
        // Save the new content to the database
        await _saveClipboardContent(currentText);
        
        // Update last known clipboard text
        _lastClipboardText = currentText;
      }
    } catch (e) {
      print('Error checking clipboard: $e');
    }
  }
  
  /// Save clipboard content to the database
  Future<void> _saveClipboardContent(String content) async {
    try {
      print('CLIPBOARD MONITOR: Saving content to database...');
      
      // Create the request
      final request = CreateClipboardItemRequest(
        content: content,
        // Let the backend auto-detect content type
      );
      
      // Save the new item to the database
      final newItemId = await _clipboardService.createClipboardItem(request);
      print('CLIPBOARD MONITOR: Content saved to database with ID: $newItemId');
      
      // Get the complete item we just created
      final newItem = await _clipboardService.getClipboardItem(newItemId);
      print('CLIPBOARD MONITOR: Retrieved new item with id ${newItem.id}');
      
      // Set this item as current in the system
      await _clipboardService.applyClipboardItem(newItem);
      print('CLIPBOARD MONITOR: Item set as current');
      
      // DIRECT APPROACH: Update the provider directly if it's registered
      if (_clipboardProvider != null) {
        print('CLIPBOARD MONITOR: Directly updating registered provider...');
        
        // Force refresh items
        await _clipboardProvider!.refreshItems();
        print('CLIPBOARD MONITOR: Items refreshed');
        
        // Manually set the current item
        _clipboardProvider!.setCurrentItem(newItem);
        print('CLIPBOARD MONITOR: Current item updated');
      } else {
        print('CLIPBOARD MONITOR: No provider registered, UI won\'t update automatically');
        
        // TRY BACKUP APPROACH using Provider.of
        try {
          final context = navigatorKey.currentContext;
          if (context != null) {
            print('CLIPBOARD MONITOR: Found valid context, trying context-based update');
            final provider = Provider.of<ClipboardProvider>(context, listen: false);
            await provider.refreshItems();
            provider.setCurrentItem(newItem);
            print('CLIPBOARD MONITOR: Context-based provider update succeeded');
          }
        } catch (e) {
          print('CLIPBOARD MONITOR: Context-based update failed: $e');
        }
      }
    } catch (e) {
      print('CLIPBOARD MONITOR ERROR: Error saving clipboard to database: $e');
    }
  }
  

}
