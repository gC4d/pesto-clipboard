import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/clipboard_item.dart';


class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api/v1';
  
  // Dio client with configuration
  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  /// Get all clipboard items
  Future<List<ClipboardItem>> getAllClipboardItems() async {
    try {
      final response = await _dio.get('/clipboard-items');
      
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        final List<dynamic> data = List.from(response.data);
        return data.map((item) => ClipboardItem.fromJson(item)).toList();
      } else {
        throw HttpException('Failed to load clipboard items: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching clipboard items: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching clipboard items: $e');
    }
  }
  
  /// Get a clipboard item by ID
  Future<ClipboardItem> getClipboardItemById(String id) async {
    try {
      final response = await _dio.get('/clipboard-items/$id');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return ClipboardItem.fromJson(data);
      } else {
        throw HttpException('Failed to load clipboard item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching clipboard item: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching clipboard item: $e');
    }
  }
  
  /// Get the current clipboard item
  Future<ClipboardItem> getCurrentClipboardItem() async {
    try {
      final response = await _dio.get('/clipboard-items/current');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return ClipboardItem.fromJson(data);
      } else {
        throw HttpException('Failed to load current clipboard item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching current clipboard item: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching current clipboard item: $e');
    }
  }
  
  /// Get clipboard items by content type
  Future<List<ClipboardItem>> getClipboardItemsByContentType(String contentType) async {
    try {
      final response = await _dio.get('/clipboard-items/content/$contentType');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(response.data);
        return data.map((item) => ClipboardItem.fromJson(item)).toList();
      } else {
        throw HttpException('Failed to load clipboard items: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching clipboard items: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching clipboard items: $e');
    }
  }
  
  /// Create a new clipboard item
  Future<ClipboardItem> createClipboardItem(CreateClipboardItemRequest request) async {
    try {
      debugPrint('Sending POST request to /clipboard-items with data: ${request.toJson()}');
      final response = await _dio.post(
        '/clipboard-items',
        data: request.toJson(),
      );
      
      debugPrint('Received response with status code: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = response.data;
        debugPrint('Received response data: $data');
        return ClipboardItem.fromJson(data);
      } else {
        throw HttpException('Failed to create clipboard item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException when creating clipboard item: ${e.message}');
      throw Exception('Error creating clipboard item: ${e.message}');
    } catch (e) {
      debugPrint('Exception when creating clipboard item: $e');
      throw Exception('Error creating clipboard item: $e');
    }
  }
  
  /// Delete a clipboard item
  Future<void> deleteClipboardItem(String id) async {
    try {
      final response = await _dio.delete('/clipboard-items/$id');
      
      if (response.statusCode != 200) {
        throw HttpException('Failed to delete clipboard item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting clipboard item: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting clipboard item: $e');
    }
  }
}
