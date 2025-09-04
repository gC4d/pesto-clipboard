# API Service Documentation

This document explains how to use the API service to connect the Flutter frontend with the Go backend.

## Setup

1. Make sure the backend server is running on `http://localhost:8080`
2. The API service is implemented in `lib/services/api_service.dart`
3. The service uses the `dio` package for HTTP requests

## Available Methods

### Get all clipboard items
```dart
final apiService = ApiService();
final items = await apiService.getAllClipboardItems();
```

### Get a clipboard item by ID
```dart
final item = await apiService.getClipboardItemById('1');
```

### Get the current clipboard item
```dart
final currentItem = await apiService.getCurrentClipboardItem();
```

### Get clipboard items by content type
```dart
final textItems = await apiService.getClipboardItemsByContentType('TEXT');
```

### Create a new clipboard item
```dart
final request = CreateClipboardItemRequest(
  content: 'Hello, World!',
  contentType: ClipboardContentType.text,
);
final newItem = await apiService.createClipboardItem(request);
```

### Delete a clipboard item
```dart
await apiService.deleteClipboardItem('1');
```

## Usage in Widgets

The `ClipboardListScreen` demonstrates how to use the API service with proper error handling and loading states:

```dart
class _ClipboardListScreenState extends State<ClipboardListScreen> {
  final ApiService _apiService = ApiService();
  List<ClipboardItem> _clipboardItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClipboardItems();
  }

  Future<void> _loadClipboardItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await _apiService.getAllClipboardItems();
      setState(() {
        _clipboardItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI implementation with loading, error, and data states
  }
}
```

## Error Handling

All API methods include proper error handling for:
- Network errors
- Timeout errors
- HTTP status errors
- Parsing errors

Always wrap API calls in try-catch blocks to handle potential errors gracefully.

## Testing

Mock implementations are available in `api_service_test.dart` for testing components that depend on the API service.
