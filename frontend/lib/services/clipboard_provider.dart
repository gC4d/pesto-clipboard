import 'package:flutter/material.dart';

import '../models/clipboard_item.dart';
import 'clipboard_service.dart';

/// Provider class for managing clipboard state
class ClipboardProvider extends ChangeNotifier {
  final ClipboardService _clipboardService;
  
  List<ClipboardItem> _items = [];
  ClipboardItem? _currentItem;
  bool _isLoading = false;
  String? _error;
  ClipboardContentType? _filterType;
  
  /// Constructor initializes the service and starts loading data
  ClipboardProvider({ClipboardService? clipboardService}) 
      : _clipboardService = clipboardService ?? ClipboardService() {
    _initializeProvider();
  }
  
  /// Getters
  // Return items sorted by creation time (newest first)
  List<ClipboardItem> get items {
    final sortedItems = List<ClipboardItem>.from(_items);
    sortedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedItems;
  }
  ClipboardItem? get currentItem => _currentItem;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ClipboardContentType? get filterType => _filterType;
  
  /// Initialize the provider
  Future<void> _initializeProvider() async {
    // Start polling for clipboard changes and pass refreshItems as callback
    _clipboardService.startPolling((item) {
      _currentItem = item;
      notifyListeners();
    }, onItemsRefreshed: () {
      // Use a microtask to avoid potential race conditions
      Future.microtask(() => refreshItems());
    });
    
    // Load initial data
    await refreshItems();
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _clipboardService.stopPolling();
    super.dispose();
  }
  
  /// Explicitly set the current item
  void setCurrentItem(ClipboardItem item) {
    _currentItem = item;
    
    // Update the is_current flag on items
    _items = _items.map((i) => 
      i.id == item.id 
        ? i.copyWith(isCurrent: true)
        : i.copyWith(isCurrent: false)
    ).toList();
    
    notifyListeners();
  }
  
  /// Refresh clipboard items from backend
  Future<void> refreshItems() async {
    _setLoading(true);
    _error = null;
    
    try {
      final filter = _filterType != null 
          ? ClipboardFilterRequest(contentType: _filterType)
          : null;
          
      _items = await _clipboardService.getClipboardItems(filter: filter);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load clipboard items: ${e.toString()}');
    }
  }
  
  /// Apply a clipboard item (make it current)
  Future<void> applyItem(ClipboardItem item) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _clipboardService.applyClipboardItem(item);
      _currentItem = item;
      
      // Update the is_current flag on items
      _items = _items.map((i) => 
        i.id == item.id 
          ? i.copyWith(isCurrent: true)
          : i.copyWith(isCurrent: false)
      ).toList();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to apply clipboard item: ${e.toString()}');
    }
  }
  
  /// Save current system clipboard to backend
  Future<void> saveCurrentClipboard() async {
    _setLoading(true);
    _error = null;
    
    try {
      await _clipboardService.saveCurrentClipboardToBackend();
      await refreshItems();
    } catch (e) {
      _setError('Failed to save clipboard: ${e.toString()}');
    }
  }
  
  /// Filter items by content type
  Future<void> filterByType(ClipboardContentType? type) async {
    _filterType = type;
    await refreshItems();
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Set error state
  void _setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }
  
  /// Clear error state - useful for continuing in offline mode
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
