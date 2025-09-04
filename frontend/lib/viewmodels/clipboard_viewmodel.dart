import 'package:flutter/foundation.dart';
import '../models/clipboard_item.dart';
import '../services/api_service.dart';
import 'base_viewmodel.dart';

enum ClipboardViewState { initial, loading, loaded, error }

class ClipboardViewModel extends BaseViewModel {
  final ApiService _apiService;
  
  ClipboardViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();
  
  // State management
  ClipboardViewState _state = ClipboardViewState.initial;
  ClipboardViewState get state => _state;
  
  // Data
  List<ClipboardItem> _clipboardItems = [];
  List<ClipboardItem> get clipboardItems => _clipboardItems;
  
  // Current item
  ClipboardItem? _currentItem;
  ClipboardItem? get currentItem => _currentItem;
  
  // Loading state
  bool get isLoading => _state == ClipboardViewState.loading;
  bool get hasError => _state == ClipboardViewState.error;
  bool get isEmpty => _state == ClipboardViewState.loaded && _clipboardItems.isEmpty;
  
  // Private setters for internal state management
  void _setState(ClipboardViewState newState) {
    _state = newState;
    notifyListeners();
  }
  
  void _setError(String message) {
    errorMessage = message;
    _setState(ClipboardViewState.error);
  }
  
  /// Load all clipboard items
  Future<void> loadClipboardItems() async {
    _setState(ClipboardViewState.loading);
    
    try {
      final items = await _apiService.getAllClipboardItems();
      _clipboardItems = items;
      
      // Find current item
      _currentItem = items.where((item) => item.isCurrent).toList().isEmpty 
          ? null 
          : items.firstWhere((item) => item.isCurrent);
      
      _setState(ClipboardViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  /// Refresh clipboard items
  Future<void> refresh() async {
    await loadClipboardItems();
  }
  
  /// Get a clipboard item by ID
  Future<ClipboardItem?> getItemById(int id) async {
    try {
      return await _apiService.getClipboardItemById(id.toString());
    } catch (e) {
      debugPrint('Error fetching item by ID: $e');
      return null;
    }
  }
  
  /// Get the current clipboard item
  Future<ClipboardItem?> getCurrentItem() async {
    try {
      final item = await _apiService.getCurrentClipboardItem();
      _currentItem = item;
      notifyListeners();
      return item;
    } catch (e) {
      debugPrint('Error fetching current item: $e');
      return null;
    }
  }
  
  /// Get clipboard items by content type
  Future<List<ClipboardItem>> getItemsByContentType(ClipboardContentType contentType) async {
    try {
      return await _apiService.getClipboardItemsByContentType(contentType.toJson());
    } catch (e) {
      debugPrint('Error fetching items by content type: $e');
      return [];
    }
  }
  
  /// Create a new clipboard item
  Future<ClipboardItem?> createItem(CreateClipboardItemRequest request) async {
    try {
      final newItem = await _apiService.createClipboardItem(request);
      
      // Add to the list
      _clipboardItems = [newItem, ..._clipboardItems];
      
      // Update current item if needed
      if (newItem.isCurrent) {
        _currentItem = newItem;
      }
      
      notifyListeners();
      return newItem;
    } catch (e) {
      debugPrint('Error creating clipboard item: $e');
      return null;
    }
  }
  
  /// Delete a clipboard item
  Future<bool> deleteItem(int id) async {
    try {
      await _apiService.deleteClipboardItem(id.toString());
      
      // Remove from the list
      _clipboardItems = _clipboardItems.where((item) => item.id != id).toList();
      
      // Update current item if needed
      if (_currentItem?.id == id) {
        _currentItem = null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting clipboard item: $e');
      return false;
    }
  }
  
  /// Set an item as current
  Future<bool> setCurrentItem(int id) async {
    try {
      // Create a request to update the item as current
      final item = _clipboardItems.firstWhere((item) => item.id == id);
      final request = CreateClipboardItemRequest(
        content: item.content,
        contentType: item.contentType,
      );
      
      final updatedItem = await _apiService.createClipboardItem(request);
      
      // Update the list
      _clipboardItems = _clipboardItems
          .map((item) => item.id == id 
              ? updatedItem.copyWith(isCurrent: true) 
              : item.copyWith(isCurrent: false))
          .toList();
      
      _currentItem = updatedItem.copyWith(isCurrent: true);
      notifyListeners();
      
      return true;
    } catch (e) {
      debugPrint('Error setting current clipboard item: $e');
      return false;
    }
  }
}
