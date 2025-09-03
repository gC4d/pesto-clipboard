/// Configuration class for the application
class AppConfig {
  /// Base URL for the API
  /// Using localhost with the port 8080 that Rust backend is using
  static const String apiBaseUrl = 'http://127.0.0.1:8080';
  
  /// Polling interval for checking clipboard updates (in milliseconds)
  static const int clipboardPollingInterval = 2000;
  
  /// Interval for monitoring clipboard changes (in milliseconds)
  /// Lower value means faster detection but higher resource usage
  static const int clipboardMonitorInterval = 500;
  
  /// Maximum number of items to show in the clipboard history
  static const int maxHistoryItems = 100;
  
  /// Timeout for API requests (in seconds)
  static const int apiTimeout = 10;
  
  /// Cache duration for clipboard items (in minutes)
  static const int cacheDuration = 60;
  
  /// Private constructor to prevent instantiation
  AppConfig._();
}
