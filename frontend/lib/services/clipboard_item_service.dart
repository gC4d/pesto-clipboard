import 'package:flutter/foundation.dart';
import '../models/clipboard_item.dart';
import 'api_service.dart';

/// Service that handles clipboard item operations
/// This is a wrapper around ApiService with additional business logic
class ClipboardItemService {
  final ApiService _apiService = ApiService();
  
  /// Get all clipboard items
  Future<List<ClipboardItem>> getAllClipboardItems() async {
    try {
      return await _apiService.getAllClipboardItems();
    } catch (e) {
      debugPrint('Error getting clipboard items: $e');
      rethrow;
    }
  }
  
  /// Create a new clipboard item
  Future<ClipboardItem?> createClipboardItem(CreateClipboardItemRequest request) async {
    try {
      debugPrint('Sending clipboard item to backend: ${request.content}');
      final result = await _apiService.createClipboardItem(request);
      debugPrint('Successfully sent clipboard item to backend');
      return result;
    } catch (e) {
      debugPrint('Error creating clipboard item: $e');
      return null;
    }
  }
  
  /// Get clipboard items by content type
  Future<List<ClipboardItem>> getClipboardItemsByContentType(ClipboardContentType contentType) async {
    try {
      return await _apiService.getClipboardItemsByContentType(contentType.toJson());
    } catch (e) {
      debugPrint('Error getting clipboard items by content type: $e');
      return [];
    }
  }
  
  /// Delete a clipboard item
  Future<bool> deleteClipboardItem(int id) async {
    try {
      await _apiService.deleteClipboardItem(id.toString());
      return true;
    } catch (e) {
      debugPrint('Error deleting clipboard item: $e');
      return false;
    }
  }
  
  /// Set an item as current
  Future<ClipboardItem?> setCurrentItem(int id) async {
    try {
      // Get the item first
      final items = await _apiService.getAllClipboardItems();
      final item = items.firstWhere((item) => item.id == id);
      
      // Create a new item request to set it as current
      final request = CreateClipboardItemRequest(
        content: item.content,
        contentType: item.contentType,
      );
      
      return await _apiService.createClipboardItem(request);
    } catch (e) {
      debugPrint('Error setting current clipboard item: $e');
      return null;
    }
  }
}
