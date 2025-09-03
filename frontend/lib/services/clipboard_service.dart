import 'dart:async';
import 'package:flutter/services.dart';
import '../models/clipboard_item.dart';
import '../config/app_config.dart';
import 'api_service.dart';

/// Service to interact with clipboard and backend
class ClipboardService {
  final ApiService _apiService;
  Timer? _pollingTimer;
  
  /// Constructor initializes API service
  ClipboardService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();
  
  /// Start polling for clipboard changes
  void startPolling(Function(ClipboardItem?) onCurrentItemChanged, {Function? onItemsRefreshed}) {
    // Cancel existing timer if it exists
    _pollingTimer?.cancel();
    
    // Create a new timer that periodically checks for clipboard updates
    _pollingTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.clipboardPollingInterval),
      (_) => _checkForClipboardUpdates(onCurrentItemChanged, onItemsRefreshed: onItemsRefreshed),
    );
  }
  
  /// Stop polling for clipboard changes
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
  /// Check for updates to the current clipboard item
  Future<void> _checkForClipboardUpdates(
    Function(ClipboardItem?) onCurrentItemChanged, {
    Function? onItemsRefreshed,
  }) async {
    try {
      final currentItem = await _apiService.getCurrentClipboardItem();
      onCurrentItemChanged(currentItem);
      
      // Also trigger items refresh if the callback is provided
      if (onItemsRefreshed != null) {
        print('ClipboardService: Triggering items refresh');
        onItemsRefreshed();
      }
    } catch (e) {
      // Check if this is a 404 error (no current item)
      if (e.toString().contains('404') || 
          e.toString().contains('Item not found')) {
        // This is expected when there's no current item
        print('No current clipboard item');
        onCurrentItemChanged(null);
      } else {
        // For other errors, use the error handler
        _handleError(e, 'checking clipboard updates');
        onCurrentItemChanged(null);
      }
    }
  }
  
  /// Error handler for API exceptions
  void _handleError(dynamic error, String context) {
    // Check if it's a connection error (backend not running)
    if (error.toString().contains('Connection refused')) {
      print('Backend connection error: Backend server not running');
      // We'll handle this gracefully in the UI
      throw ApiException('Backend server not available');
    } else {
      // Log the error
      print('Error $context: ${error.toString()}');
      
      // Rethrow the error so that the caller can handle it
      throw error;
    }
  }
  
  /// Get all clipboard items from backend
  Future<List<ClipboardItem>> getClipboardItems({
    ClipboardFilterRequest? filter,
  }) async {
    try {
      final response = await _apiService.getClipboardItems(filter: filter);
      print(response);
      return response.items;
    } catch (e) {
      _handleError(e, 'getting clipboard items');
      rethrow;
    }
  }
  
  /// Apply a clipboard item (make it the current item)
  Future<void> applyClipboardItem(ClipboardItem item) async {
    await _apiService.applyClipboardItem(item.id);
    
    // Also set the clipboard content in the system clipboard
    switch (item.contentType) {
      case ClipboardContentType.text:
      case ClipboardContentType.code:
        await Clipboard.setData(ClipboardData(text: item.content));
        break;
      case ClipboardContentType.image:
        // For images, we would need platform-specific code
        // This is a simplified approach - in a real app you might need
        // platform channels for more complex clipboard operations
        print('Image clipboard apply not fully implemented');
        break;
    }
  }
  
  /// Save current system clipboard content to backend
  Future<void> saveCurrentClipboardToBackend() async {
    try {
      // Get text from clipboard
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      
      if (clipboardData?.text != null) {
        final request = CreateClipboardItemRequest(
          content: clipboardData!.text!,
          // Let the backend auto-detect the content type
        );
        
        await _apiService.createClipboardItem(request);
      }
      // Note: For images and other types, we would need platform channels
      
    } catch (e) {
      print('Error saving clipboard to backend: $e');
      rethrow;
    }
  }
  
  /// Get a specific clipboard item
  Future<ClipboardItem> getClipboardItem(String id) async {
    return await _apiService.getClipboardItem(id);
  }
  
  /// Get the current clipboard item
  Future<ClipboardItem?> getCurrentClipboardItem() async {
    try {
      return await _apiService.getCurrentClipboardItem();
    } catch (e) {
      return null;
    }
  }
  
  /// Create a new clipboard item
  Future<String> createClipboardItem(CreateClipboardItemRequest request) async {
    try {
      return await _apiService.createClipboardItem(request);
    } catch (e) {
      _handleError(e, 'creating clipboard item');
      rethrow;
    }
  }
}
