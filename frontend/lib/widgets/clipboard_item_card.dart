import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';
import '../utils/date_formatter.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: item.isCurrent 
          ? BorderSide(color: colorScheme.primary, width: 2)
          : BorderSide(color: colorScheme.outline, width: 1),
      ),
      elevation: theme.cardTheme.elevation ?? 0,
      color: theme.cardTheme.color,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ContentTypeIcon(contentType: item.contentType),
                  const SizedBox(width: 8),
                  Text(
                    _getContentTypeText(),
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormatter.format(item.createdAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Content preview
              ContentPreview(item: item),
              const SizedBox(height: 16),
              // Bottom row with actions
              Row(
                children: [
                  // Current indicator
                  if (item.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Current',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  if (!item.isCurrent)
                    ElevatedButton(
                      onPressed: onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        minimumSize: const Size(0, 36),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: const Size(0, 36),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
}
