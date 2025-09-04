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

    switch (item.contentType) {
      case ClipboardContentType.text:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
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
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            height: 120,
            clipBehavior: Clip.antiAlias,
            child: Image.memory(
              imageData,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(
                      child: Icon(Icons.broken_image,
                          size: 48,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withValues(alpha: 0.5))),
            ),
          );
        } catch (e) {
          return Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image,
                      size: 32,
                      color: Theme.of(context)
                          .iconTheme
                          .color
                          ?.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text('Image preview unavailable',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
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
            color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Text(
            item.content.length > 150
                ? '${item.content.substring(0, 150)}...'
                : item.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
