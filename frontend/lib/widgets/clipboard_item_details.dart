import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/clipboard_item.dart';
import '../utils/date_formatter.dart';

/// Widget for displaying detailed view of a clipboard item
class ClipboardItemDetails extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onApply;
  
  const ClipboardItemDetails({
    super.key,
    required this.item,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildContentTypeIcon(),
                    const SizedBox(width: 12),
                    Text(
                      _getContentTypeText(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Created: ${DateFormatter.formatDate(item.createdAt)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormatter.formatTime(item.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Divider(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: _buildContentDetail(context),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _copyToClipboard(context);
                  },
                  child: const Text('Copy'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onApply,
                  icon: const Icon(Icons.content_paste),
                  label: const Text('Apply to Clipboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build the content type icon based on the content type
  Widget _buildContentTypeIcon() {
    IconData iconData;
    Color iconColor;
    
    switch (item.contentType) {
      case ClipboardContentType.text:
        iconData = Icons.text_fields;
        iconColor = Colors.blue;
        break;
      case ClipboardContentType.image:
        iconData = Icons.image;
        iconColor = Colors.green;
        break;
      case ClipboardContentType.code:
        iconData = Icons.code;
        iconColor = Colors.deepPurple;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
  
  /// Get the content type text
  String _getContentTypeText() {
    switch (item.contentType) {
      case ClipboardContentType.text:
        return 'Text Content';
      case ClipboardContentType.image:
        return 'Image';
      case ClipboardContentType.code:
        return 'Code Snippet';
    }
  }
  
  /// Build the detailed content view based on the content type
  Widget _buildContentDetail(BuildContext context) {
    switch (item.contentType) {
      case ClipboardContentType.text:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(item.content),
        );
      
      case ClipboardContentType.image:
        try {
          final imageData = base64Decode(item.content);
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.memory(
              imageData,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => 
                  const Center(child: Icon(Icons.broken_image, size: 64)),
            ),
          );
        } catch (e) {
          return const Center(
            child: Column(
              children: [
                Icon(Icons.broken_image, size: 64),
                SizedBox(height: 8),
                Text('Failed to load image'),
              ],
            ),
          );
        }
      
      case ClipboardContentType.code:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item.content,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        );
    }
  }
  
  /// Copy content to clipboard and show a snackbar
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: item.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
