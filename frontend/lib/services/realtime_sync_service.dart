import 'dart:async';
import 'package:flutter/foundation.dart';
import 'clipboard_item_service.dart';
import '../models/clipboard_item.dart';

/// Service that handles real-time synchronization with the backend
/// Uses polling as the synchronization mechanism
class RealtimeSyncService {
  static final RealtimeSyncService _instance = RealtimeSyncService._internal();
  factory RealtimeSyncService() => _instance;
  RealtimeSyncService._internal();
  
  final ClipboardItemService _clipboardItemService = ClipboardItemService();
  
  Timer? _syncTimer;
  List<ClipboardItem> _lastKnownItems = [];
  DateTime _lastSyncTime = DateTime.now();
  
  // Configuration
  static const Duration _syncInterval = Duration(seconds: 5); // Poll every 5 seconds
  static const Duration _minTimeBetweenSyncs = Duration(seconds: 1);
  
  bool _isSyncing = false;
  bool _disposed = false;
  
  /// Callback for when clipboard items are updated
  Function(List<ClipboardItem>)? onItemsUpdated;
  
  /// Callback for when a new item is added
  Function(ClipboardItem)? onNewItem;
  
  /// Start real-time synchronization
  void startSync() {
    if (_isSyncing || _disposed) return;
    
    _isSyncing = true;
    _lastKnownItems = [];
    
    // Start periodic synchronization
    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      await _syncWithBackend();
    });
    
    // Do an initial sync
    _syncWithBackend();
    
    debugPrint('Real-time synchronization started');
  }
  
  /// Stop real-time synchronization
  void stopSync() {
    _isSyncing = false;
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('Real-time synchronization stopped');
  }
  
  /// Synchronize with the backend
  Future<void> _syncWithBackend() async {
    // Prevent excessive syncing
    final now = DateTime.now();
    if (now.difference(_lastSyncTime) < _minTimeBetweenSyncs) {
      return;
    }
    _lastSyncTime = now;
    
    try {
      debugPrint('Syncing with backend...');
      
      // Get all clipboard items from backend
      final items = await _clipboardItemService.getAllClipboardItems();
      
      debugPrint('Retrieved ${items.length} clipboard items from backend');
      
      // Check if items have changed
      if (!_listsEqual(_lastKnownItems, items)) {
        debugPrint('Clipboard items have changed, updating UI');
        
        // Update last known items
        _lastKnownItems = List.from(items);
        
        // Notify listeners of full update
        if (onItemsUpdated != null) {
          onItemsUpdated!(items);
        }
        
        // Check for new items
        if (onNewItem != null && items.isNotEmpty) {
          // Find items that didn't exist before
          final newItems = items.where((item) {
            return !_lastKnownItems.any((knownItem) => knownItem.id == item.id);
          }).toList();
          
          debugPrint('Found ${newItems.length} new items');
          
          // Notify for each new item
          for (final newItem in newItems) {
            onNewItem!(newItem);
          }
        }
        
        debugPrint('Synchronized ${items.length} clipboard items');
      } else {
        debugPrint('No changes in clipboard items');
      }
    } catch (e) {
      debugPrint('Error synchronizing with backend: $e');
      // Don't stop syncing on error, just log it
    }
  }
  
  /// Compare two lists of clipboard items for equality
  bool _listsEqual(List<ClipboardItem> list1, List<ClipboardItem> list2) {
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id ||
          list1[i].content != list2[i].content ||
          list1[i].contentType != list2[i].contentType ||
          list1[i].isCurrent != list2[i].isCurrent) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Force a synchronization
  Future<void> forceSync() async {
    await _syncWithBackend();
  }
  
  /// Dispose of the service
  void dispose() {
    if (_disposed) return;
    
    stopSync();
    _disposed = true;
    
    debugPrint('Real-time sync service disposed');
  }
}
