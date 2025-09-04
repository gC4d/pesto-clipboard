import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';
import '../utils/date_formatter.dart';
import 'content_type_icon.dart';
import 'content_preview.dart';

/// Widget for displaying a clipboard item in a card
class ClipboardItemCard extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  
  const ClipboardItemCard({
    super.key,
    required this.item,
    required this.onTap,
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
    
    // For image content, make the card have a fixed height but same width as others
    final isImage = item.contentType == ClipboardContentType.image;
    final cardWidth = double.infinity;
    final cardHeight = isImage ? 220.0 : null;
    
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
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                // Content preview
                if (isImage)
                  // For images, give them a fixed height
                  SizedBox(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ContentPreview(item: item),
                    ),
                  )
                else
                  // For text and code, use normal sizing
                  ContentPreview(item: item),
                const SizedBox(height: 16),
                // Bottom row with actions
                Flexible(
                  child: Row(
                    children: [
                      // Current indicator
                      if (item.isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
