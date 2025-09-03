import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/clipboard_item.dart';
import '../services/clipboard_provider.dart';
import '../widgets/clipboard_item_card.dart';
import '../widgets/clipboard_item_details.dart';
import '../utils/app_theme.dart';

/// Main screen for displaying the clipboard history
class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({Key? key}) : super(key: key);

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  String _searchQuery = '';
  ClipboardContentType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipboard history'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: Consumer<ClipboardProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  bool isOfflineError = provider.error.toString().contains('not available');
                  
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOfflineError ? Icons.cloud_off : Icons.error_outline,
                          color: isOfflineError ? Colors.orange : Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isOfflineError ? 'Backend Server Not Available' : 'Error loading clipboard items',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            isOfflineError 
                              ? 'The Rust backend server is not running. Start the backend server and restart the application.'
                              : provider.error.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.refreshItems(),
                          child: const Text('Retry'),
                        ),
                        if (isOfflineError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextButton(
                              onPressed: () {
                                // Just continue using the app in demo/offline mode
                                provider.clearError();
                              },
                              child: const Text('Continue in Offline Mode'),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                final filteredItems = _filterItems(provider.items);
                
                if (filteredItems.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => provider.refreshItems(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ClipboardItemCard(
                        item: item,
                        onTap: () => _showItemDetails(item),
                        onApply: () => _applyItem(item),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build the search and filter bar at the top of the list
  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.win11CardBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field - Windows 11 style
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for something...',
              prefixIcon: Icon(Icons.search, color: AppTheme.win11Blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppTheme.win11Blue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          // Filter options and refresh button
          Row(
            children: [
              const Text('Content type:', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              // Windows 11 style filter chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(null, 'All'),
                      const SizedBox(width: 8),
                      _buildFilterChip(ClipboardContentType.text, 'Text'),
                      const SizedBox(width: 8),
                      _buildFilterChip(ClipboardContentType.image, 'Image'),
                      const SizedBox(width: 8),
                      _buildFilterChip(ClipboardContentType.code, 'Code'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Refresh button
              IconButton(
                icon: Icon(Icons.refresh, color: AppTheme.win11Blue),
                onPressed: () {
                  final provider = Provider.of<ClipboardProvider>(context, listen: false);
                  provider.refreshItems();
                },
                tooltip: 'Refresh clipboard items',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the empty state when no items are found
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No clipboard items found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != null
                ? 'Try changing your search or filter options'
                : 'Copy something to get started',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ClipboardProvider>().saveCurrentClipboard();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Current Clipboard'),
          ),
        ],
      ),
    );
  }

  /// Show details dialog for an item
  void _showItemDetails(ClipboardItem item) {
    showDialog(
      context: context,
      builder: (context) => ClipboardItemDetails(
        item: item,
        onApply: () {
          Navigator.of(context).pop();
          _applyItem(item);
        },
      ),
    );
  }

  /// Apply an item to the clipboard
  void _applyItem(ClipboardItem item) {
    context.read<ClipboardProvider>().applyItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Applied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Filter items based on search query
  List<ClipboardItem> _filterItems(List<ClipboardItem> items) {
    if (_searchQuery.isEmpty) {
      return items;
    }
    
    return items.where((item) {
      if (item.contentType == ClipboardContentType.image) {
        return false; // Can't search in images
      }
      
      return item.content.toLowerCase().contains(_searchQuery);
    }).toList();
  }
  
  // Windows 11 style filter chip
  Widget _buildFilterChip(ClipboardContentType? type, String label) {
    final isSelected = _selectedFilter == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = type;
        });
        // Also update provider filter
        context.read<ClipboardProvider>().filterByType(type);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.win11Blue : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppTheme.win11Blue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
