import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';
import '../utils/date_formatter.dart';
import '../utils/app_theme.dart';
import 'content_type_icon.dart';
import 'content_preview.dart';

/// Widget for displaying a clipboard item in a card
class ClipboardItemCard extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  final VoidCallback onApply;
  
  const ClipboardItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: item.isCurrent 
          ? BorderSide(color: colorScheme.primary, width: 2)
          : BorderSide(color: theme.dividerColor, width: 1),
      ),
      elevation: theme.cardTheme.elevation ?? 0,
      color: theme.cardTheme.color,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
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
                  ContentTypeIcon(contentType: item.contentType),
                  const SizedBox(width: 8),
                  Text(
                    _getContentTypeText(),
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormatter.format(item.createdAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Divider(height: 16, color: AppTheme.win11Divider),
              // Content preview
              ContentPreview(item: item),
              const SizedBox(height: 12),
              // Bottom row with actions
              Row(
                children: [
                  // Current indicator
                  if (item.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Current',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
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
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                        foregroundColor: colorScheme.onPrimary,
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
                      foregroundColor: colorScheme.primary.withValues(alpha: 0.7),
                      side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
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
}
