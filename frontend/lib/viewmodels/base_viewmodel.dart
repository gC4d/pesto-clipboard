import 'package:flutter/foundation.dart';

class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;
  bool get disposed => _disposed;
  
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  set errorMessage(String? value) {
    if (_errorMessage != value) {
      _errorMessage = value;
      notifyListeners();
    }
  }
  
  void clearError() {
    errorMessage = null;
  }
}
