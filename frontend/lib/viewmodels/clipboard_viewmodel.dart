import 'package:flutter/foundation.dart';
import '../models/clipboard_item.dart';
import '../services/api_service.dart';
import '../services/clipboard_item_service.dart';
import 'base_viewmodel.dart';

enum ClipboardViewState { initial, loading, loaded, error }

class ClipboardViewModel extends BaseViewModel {
  final ClipboardItemService _clipboardItemService;
  
  ClipboardViewModel({
    ApiService? apiService,
    ClipboardItemService? clipboardItemService,
  }) : _clipboardItemService = clipboardItemService ?? ClipboardItemService();
  
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
    debugPrint('Loading clipboard items...');
    
    try {
      final items = await _clipboardItemService.getAllClipboardItems();
      debugPrint('Loaded ${items.length} clipboard items');
      _clipboardItems = items;
      
      // Find current item
      _currentItem = items.where((item) => item.isCurrent).toList().isEmpty 
          ? null 
          : items.firstWhere((item) => item.isCurrent);
      
      _setState(ClipboardViewState.loaded);
      debugPrint('Clipboard items loaded successfully');
    } catch (e) {
      debugPrint('Error loading clipboard items: $e');
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
      final items = await _clipboardItemService.getAllClipboardItems();
      try {
        return items.firstWhere((item) => item.id == id);
      } catch (e) {
        // firstWhere throws if no element is found
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching item by ID: $e');
      return null;
    }
  }
  
  /// Get the current clipboard item
  Future<ClipboardItem?> getCurrentItem() async {
    try {
      final items = await _clipboardItemService.getAllClipboardItems();
      try {
        final currentItem = items.firstWhere((item) => item.isCurrent);
        _currentItem = currentItem;
        notifyListeners();
        return currentItem;
      } catch (e) {
        // firstWhere throws if no element is found
        _currentItem = null;
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching current item: $e');
      return null;
    }
  }
  
  /// Get clipboard items by content type
  Future<List<ClipboardItem>> getItemsByContentType(ClipboardContentType contentType) async {
    try {
      return await _clipboardItemService.getClipboardItemsByContentType(contentType);
    } catch (e) {
      debugPrint('Error fetching items by content type: $e');
      return [];
    }
  }
  
  /// Create a new clipboard item
  Future<ClipboardItem?> createItem(CreateClipboardItemRequest request) async {
    try {
      final newItem = await _clipboardItemService.createClipboardItem(request);
      
      if (newItem != null) {
        // Add to the list
        _clipboardItems = [newItem, ..._clipboardItems];
        
        // Update current item if needed
        if (newItem.isCurrent) {
          _currentItem = newItem;
        }
        
        notifyListeners();
      }
      
      return newItem;
    } catch (e) {
      debugPrint('Error creating clipboard item: $e');
      return null;
    }
  }
  
  /// Delete a clipboard item
  Future<bool> deleteItem(int id) async {
    try {
      final success = await _clipboardItemService.deleteClipboardItem(id);
      
      if (success) {
        // Remove from the list
        _clipboardItems = _clipboardItems.where((item) => item.id != id).toList();
        
        // Update current item if needed
        if (_currentItem?.id == id) {
          _currentItem = null;
        }
        
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      debugPrint('Error deleting clipboard item: $e');
      return false;
    }
  }
  
  /// Set an item as current
  Future<bool> setCurrentItem(int id) async {
    try {
      final updatedItem = await _clipboardItemService.setCurrentItem(id);
      
      if (updatedItem != null) {
        // Update the list
        _clipboardItems = _clipboardItems
            .map((item) => item.id == id 
                ? updatedItem.copyWith(isCurrent: true) 
                : item.copyWith(isCurrent: false))
            .toList();
        
        _currentItem = updatedItem.copyWith(isCurrent: true);
        notifyListeners();
        
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error setting current clipboard item: $e');
      return false;
    }
  }
}
