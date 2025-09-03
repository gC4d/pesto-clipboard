import 'dart:async';
import 'package:dio/dio.dart';

import '../models/clipboard_item.dart';
import '../config/app_config.dart';

/// Service class for interacting with the backend API
class ApiService {
  final Dio _dio;
  
  /// Constructor initializes Dio with base URL and timeout settings
  /// Optional [dio] parameter for dependency injection in tests
  ApiService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        )) {
    // Don't add interceptors if using a mock dio for testing
    if (dio == null) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj.toString()),
      ));
    }
  }

  /// Create a new clipboard item
  Future<String> createClipboardItem(CreateClipboardItemRequest request) async {
    try {
      final response = await _dio.post(
        '/clipboard',
        data: request.toJson(),
      );
      return response.data['id'];
    } catch (e) {
      _handleError(e, 'Failed to create clipboard item');
      rethrow;
    }
  }

  /// Get a list of all clipboard items
  Future<ClipboardListResponse> getClipboardItems({
    ClipboardFilterRequest? filter,
  }) async {
    try {
      final Map<String, String> queryParams = filter?.toQueryParameters() ?? {};
      
      final response = await _dio.get(
        '/clipboard',
        queryParameters: queryParams,
      );
      print("penis");
      print(response.data);
      return ClipboardListResponse.fromJson(response.data);
    } catch (e) {
        print(e);
      _handleError(e, 'Failed to get clipboard items');
      rethrow;
    }
  }

  /// Get a specific clipboard item by ID
  Future<ClipboardItem> getClipboardItem(String id) async {
    try {
      final response = await _dio.get('/clipboard/$id');
      return ClipboardItem.fromJson(response.data);
    } catch (e) {
      _handleError(e, 'Failed to get clipboard item');
      rethrow;
    }
  }

  /// Apply a clipboard item (set as current)
  Future<void> applyClipboardItem(String id) async {
    try {
      await _dio.post('/clipboard/$id/apply');
    } catch (e) {
      _handleError(e, 'Failed to apply clipboard item');
      rethrow;
    }
  }

  /// Get the current clipboard item
  Future<ClipboardItem> getCurrentClipboardItem() async {
    try {
      final response = await _dio.get('/clipboard/current');
      print("hi");
      print(response.data);
      return ClipboardItem.fromJson(response.data);
    } catch (e) {
      _handleError(e, 'Failed to get current clipboard item');
      rethrow;
    }
  }

  /// Handle API errors
  void _handleError(dynamic error, String fallbackMessage) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        final Map<String, dynamic>? data = response.data;
        if (data != null && data.containsKey('error')) {
          throw ApiException(data['error']);
        }
      }
    }
    
    throw ApiException(fallbackMessage);
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
