import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'clipboard_item_service.dart';
import '../models/clipboard_item.dart';

/// Service that monitors the system clipboard for changes
/// and automatically sends new content to the backend API
class ClipboardMonitorService {
  static final ClipboardMonitorService _instance = ClipboardMonitorService._internal();
  factory ClipboardMonitorService() => _instance;
  ClipboardMonitorService._internal();

  final ClipboardItemService _clipboardItemService = ClipboardItemService();
  
  Timer? _monitoringTimer;
  String? _lastClipboardContent;
  DateTime _lastCheckTime = DateTime.now();
  
  // Configuration
  static const Duration _checkInterval = Duration(milliseconds: 500);
  static const Duration _minTimeBetweenChecks = Duration(milliseconds: 100);
  
  bool _isMonitoring = false;
  bool _disposed = false;
  
  /// Callback for when a new clipboard item is detected
  Function(ClipboardItem)? onNewItem;
  
  /// Start monitoring the clipboard
  void startMonitoring() {
    if (_isMonitoring || _disposed) return;
    
    _isMonitoring = true;
    _lastClipboardContent = null; // Reset last content
    
    // Start periodic monitoring
    _monitoringTimer = Timer.periodic(_checkInterval, (timer) async {
      await _checkClipboard();
    });
    
    debugPrint('Clipboard monitoring started');
  }
  
  /// Stop monitoring the clipboard
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    debugPrint('Clipboard monitoring stopped');
  }
  
  /// Check the clipboard for new content
  Future<void> _checkClipboard() async {
    // Prevent excessive checking
    final now = DateTime.now();
    if (now.difference(_lastCheckTime) < _minTimeBetweenChecks) {
      return;
    }
    _lastCheckTime = now;
    
    try {
      // Get current clipboard content
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final content = clipboardData?.text;
      
      debugPrint('Clipboard check - content: $content, lastContent: $_lastClipboardContent');
      
      // Check if content is valid and different from last content
      if (content != null && 
          content.isNotEmpty && 
          content != _lastClipboardContent) {
        
        debugPrint('New clipboard content detected: $content');
        
        // Update last content
        _lastClipboardContent = content;
        
        // Send to backend
        await _sendToBackend(content);
      }
    } catch (e) {
      debugPrint('Error checking clipboard: $e');
      // Don't stop monitoring on error, just log it
    }
  }
  
  /// Send clipboard content to backend
  Future<void> _sendToBackend(String content) async {
    try {
      debugPrint('Sending new clipboard content to backend');
      
      // Create clipboard item
      final request = CreateClipboardItemRequest(
        content: content,
        contentType: ClipboardContentType.text, // Auto-detect in backend
      );
      
      // Send to backend
      final newItem = await _clipboardItemService.createClipboardItem(request);
      
      // Notify listeners
      if (onNewItem != null && newItem != null) {
        onNewItem!(newItem);
      }
      
      debugPrint('Clipboard content sent successfully');
    } catch (e) {
      debugPrint('Error sending clipboard content to backend: $e');
      // We don't rethrow here to prevent stopping the monitoring
    }
  }
  
  /// Dispose of the service
  void dispose() {
    if (_disposed) return;
    
    stopMonitoring();
    _disposed = true;
    
    debugPrint('Clipboard monitor service disposed');
  }
}
