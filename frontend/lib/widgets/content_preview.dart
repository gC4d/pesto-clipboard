import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';

/// A widget that displays a preview of the clipboard content
class ContentPreview extends StatelessWidget {
  final ClipboardItem item;

  const ContentPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (item.contentType) {
      case ClipboardContentType.text:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: colorScheme.onSurface,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );

      case ClipboardContentType.image:
        try {
          final imageData = base64Decode(item.content);
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.memory(
              imageData,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(
                      child: Icon(Icons.broken_image,
                          size: 48,
                          color: colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
          );
        } catch (e) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image,
                      size: 32,
                      color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text('Image preview unavailable',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 13)),
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
            color: colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.4,
              color: colorScheme.onSurface,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        );
    }
  }
}
