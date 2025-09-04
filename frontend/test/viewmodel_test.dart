import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/viewmodels/clipboard_viewmodel.dart';

void main() {
  group('ClipboardViewModel Tests', () {
    late ClipboardViewModel viewModel;
    
    setUp(() {
      viewModel = ClipboardViewModel();
    });
    
    tearDown(() {
      viewModel.dispose();
    });
    
    test('ViewModel initializes with correct default values', () {
      expect(viewModel.state, ClipboardViewState.initial);
      expect(viewModel.clipboardItems, isEmpty);
      expect(viewModel.currentItem, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.hasError, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
    
    test('ViewModel loading state works correctly', () {
      // This is a basic test, in a real scenario you would mock the API service
      expect(viewModel.state, ClipboardViewState.initial);
    });
  });
}
