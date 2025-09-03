import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/models/clipboard_item.dart';

// Generate mock classes
@GenerateMocks([Dio])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(dio: mockDio);
  });

  group('ApiService Tests', () {
    test('getClipboardItems returns items correctly', () async {
      when(mockDio.get('/clipboard', queryParameters: {})).thenAnswer((_) async => 
        Response(
          data: {
            'items': [
              {
                'id': '123e4567-e89b-12d3-a456-426614174000',
                'content': 'Test content',
                'content_type': 'TEXT',
                'created_at': '2025-06-19T10:00:00Z',
                'updated_at': '2025-06-19T10:00:00Z',
                'is_current': true
              }
            ],
            'count': 1
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/clipboard')
        )
      );

      final result = await apiService.getClipboardItems();
      
      expect(result.items.length, 1);
      expect(result.count, 1);
      expect(result.items[0].content, 'Test content');
      expect(result.items[0].contentType, ClipboardContentType.text);
    });

    test('applyClipboardItem calls API correctly', () async {
      when(mockDio.post('/clipboard/123/apply')).thenAnswer((_) async => 
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/clipboard/123/apply')
        )
      );

      await apiService.applyClipboardItem('123');
      
      verify(mockDio.post('/clipboard/123/apply')).called(1);
    });
  });
}
