import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a DateTime to a readable string
  /// Example: "Today, 2:30 PM" or "Yesterday, 3:45 PM" or "Jun 15, 10:20 AM"
  static String format(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);
    
    final timeFormatter = DateFormat('h:mm a');
    
    if (dateDay == today) {
      return 'Today, ${timeFormatter.format(date)}';
    } else if (dateDay == yesterday) {
      return 'Yesterday, ${timeFormatter.format(date)}';
    } else {
      return '${DateFormat('MMM d').format(date)}, ${timeFormatter.format(date)}';
    }
  }
  
  /// Format a DateTime to show just the time
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
  
  /// Format a DateTime to show just the date
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);
    
    if (dateDay == today) {
      return 'Today';
    } else if (dateDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
