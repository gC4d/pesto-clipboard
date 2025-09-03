import 'package:uuid/uuid.dart';

/// Represents the type of content stored in a clipboard item
enum ClipboardContentType {
  text,
  image,
  code,
}

/// Extension to handle serialization of ClipboardContentType
extension ClipboardContentTypeExtension on ClipboardContentType {
  String toJson() {
    switch (this) {
      case ClipboardContentType.text:
        return 'TEXT';
      case ClipboardContentType.image:
        return 'IMAGE';
      case ClipboardContentType.code:
        return 'CODE';
    }
  }

  static ClipboardContentType fromJson(String json) {
    switch (json) {
      case 'TEXT':
        return ClipboardContentType.text;
      case 'IMAGE':
        return ClipboardContentType.image;
      case 'CODE':
        return ClipboardContentType.code;
      default:
        return ClipboardContentType.text;
    }
  }
}

/// Model class for clipboard items
class ClipboardItem {
  final String id;
  final String content; // Base64 for images, plain text for text/code
  final ClipboardContentType contentType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCurrent;

  ClipboardItem({
    required this.id,
    required this.content,
    required this.contentType,
    required this.createdAt,
    required this.updatedAt,
    required this.isCurrent,
  });

  /// Create a clipboard item from JSON
  factory ClipboardItem.fromJson(Map<String, dynamic> json) {
    // Handle date arrays from the Rust backend
    DateTime parseDateTime(dynamic dateValue) {
      if (dateValue is List) {
        // Format appears to be [year, day_of_year, hour, minute, second, nanos, 0, 0, 0]
        final year = dateValue[0] as int;
        final dayOfYear = dateValue[1] as int;
        final hour = dateValue[2] as int;
        final minute = dateValue[3] as int;
        final second = dateValue[4] as int;
        
        // Create a DateTime for January 1st of the given year, then add days
        final date = DateTime(year, 1, 1)
            .add(Duration(days: dayOfYear - 1, hours: hour, minutes: minute, seconds: second));
        return date;
      } else if (dateValue is String) {
        // In case it's provided as an ISO string
        return DateTime.parse(dateValue);
      } else {
        // Fallback
        return DateTime.now();
      }
    }
    
    return ClipboardItem(
      id: json['id'],
      content: json['content'],
      contentType: ClipboardContentTypeExtension.fromJson(json['content_type']),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
      isCurrent: json['is_current'],
    );
  }

  /// Convert clipboard item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'content_type': contentType.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_current': isCurrent,
    };
  }

  /// Create a copy of this clipboard item with updated properties
  ClipboardItem copyWith({
    String? id,
    String? content,
    ClipboardContentType? contentType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCurrent,
  }) {
    return ClipboardItem(
      id: id ?? this.id,
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}

/// Request model for creating a new clipboard item
class CreateClipboardItemRequest {
  final String content; // Base64-encoded for images, plain text for text/code
  final ClipboardContentType? contentType; // Optional, will be auto-detected if not provided

  CreateClipboardItemRequest({
    required this.content,
    this.contentType,
  });

  /// Convert request to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'content': content,
    };
    
    if (contentType != null) {
      data['content_type'] = contentType!.toJson();
    }
    
    return data;
  }
}

/// Response model for clipboard item list
class ClipboardListResponse {
  final List<ClipboardItem> items;
  final int count;

  ClipboardListResponse({
    required this.items,
    required this.count,
  });

  /// Create a list response from JSON
  factory ClipboardListResponse.fromJson(Map<String, dynamic> json) {
    return ClipboardListResponse(
      items: (json['items'] as List)
          .map((item) => ClipboardItem.fromJson(item))
          .toList(),
      count: json['count'],
    );
  }
}

/// Filter model for clipboard items
class ClipboardFilterRequest {
  final ClipboardContentType? contentType;
  final DateTime? fromDate;
  final DateTime? toDate;

  ClipboardFilterRequest({
    this.contentType,
    this.fromDate,
    this.toDate,
  });

  /// Convert filter to query parameters
  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};
    
    if (contentType != null) {
      params['content_type'] = contentType!.toJson();
    }
    
    if (fromDate != null) {
      params['from_date'] = fromDate!.toIso8601String();
    }
    
    if (toDate != null) {
      params['to_date'] = toDate!.toIso8601String();
    }
    
    return params;
  }
}
