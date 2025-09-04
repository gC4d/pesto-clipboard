import 'package:flutter/material.dart';
import '../models/clipboard_item.dart';

/// A widget that displays an icon representing the content type
class ContentTypeIcon extends StatelessWidget {
  final ClipboardContentType contentType;

  const ContentTypeIcon({super.key, required this.contentType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    IconData iconData;
    Color iconColor;

    switch (contentType) {
      case ClipboardContentType.text:
        iconData = Icons.subject;
        iconColor = colorScheme.primary;
        break;
      case ClipboardContentType.image:
        iconData = Icons.image;
        iconColor = colorScheme.secondary;
        break;
      case ClipboardContentType.code:
        iconData = Icons.code;
        iconColor = colorScheme.tertiary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(iconData, color: iconColor, size: 16),
    );
  }
}
