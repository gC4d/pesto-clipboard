import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';
import '../utils/date_formatter.dart';
import '../utils/app_theme.dart';

/// Widget for displaying a clipboard item in a card
class ClipboardItemCard extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  final VoidCallback onApply;
  
  const ClipboardItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: item.isCurrent 
          ? BorderSide(color: AppTheme.win11Blue, width: 2)
          : BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with type and date
              Row(
                children: [
                  _buildContentTypeIcon(),
                  const SizedBox(width: 8),
                  Text(
                    _getContentTypeText(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.win11Blue,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormatter.format(item.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, color: Color(0xFFE1E5EA)),
              // Content preview
              _buildContentPreview(),
              const SizedBox(height: 12),
              // Bottom row with actions
              Row(
                children: [
                  // Current indicator
                  if (item.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.win11Blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: AppTheme.win11Blue),
                          const SizedBox(width: 4),
                          Text(
                            'Current',
                            style: TextStyle(
                              color: AppTheme.win11Blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Apply button (Windows 11 style)
                  if (!item.isCurrent)
                    ElevatedButton(
                      onPressed: onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.win11Blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(0, 32),
                        textStyle: const TextStyle(fontSize: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  const SizedBox(width: 8),
                  // View details button
                  OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.win11Blue,
                      side: BorderSide(color: AppTheme.win11Blue.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 32),
                      textStyle: const TextStyle(fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('Details'),
                  ),
                ],
              )
            ],
          ),
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
        iconData = Icons.subject;
        iconColor = AppTheme.win11Blue;
        break;
      case ClipboardContentType.image:
        iconData = Icons.image;
        iconColor = AppTheme.win11AccentBlue;
        break;
      case ClipboardContentType.code:
        iconData = Icons.code;
        iconColor = AppTheme.win11LightBlue;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(iconData, color: iconColor, size: 16),
    );
  }
  
  /// Get the content type text
  String _getContentTypeText() {
    switch (item.contentType) {
      case ClipboardContentType.text:
        return 'Text';
      case ClipboardContentType.image:
        return 'Image';
      case ClipboardContentType.code:
        return 'Code';
    }
  }
  
  /// Build the content preview based on the content type
  Widget _buildContentPreview() {
    switch (item.contentType) {
      case ClipboardContentType.text:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: const TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      
      case ClipboardContentType.image:
        try {
          final imageData = base64Decode(item.content);
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade200),
            ),
            height: 120,
            clipBehavior: Clip.antiAlias,
            child: Image.memory(
              imageData,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey.shade400)),
            ),
          );
        } catch (e) {
          return Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('Image preview unavailable', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)
                  ),
                ],
              ),
            ),
          );
        }
      
      case ClipboardContentType.code:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        );
    }
  }
}
