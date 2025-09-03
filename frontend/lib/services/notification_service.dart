import 'package:flutter/material.dart';

/// Service for displaying notifications to the user
class NotificationService {
  /// The global key for the scaffold messenger
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  /// Get the global key for the scaffold messenger
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => _scaffoldMessengerKey;
  
  /// Show a notification toast
  void showNotification({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIconForType(type),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForType(type),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  /// Get the icon for the notification type
  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.info:
      default:
        return Icons.info_outline;
    }
  }
  
  /// Get the color for the notification type
  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green[700]!;
      case NotificationType.error:
        return Colors.red[700]!;
      case NotificationType.warning:
        return Colors.orange[700]!;
      case NotificationType.info:
      default:
        return Colors.blue[700]!;
    }
  }
}

/// Notification types for different visual styling
enum NotificationType {
  info,
  success,
  warning,
  error,
}
