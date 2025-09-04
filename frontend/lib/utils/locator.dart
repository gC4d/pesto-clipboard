import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/clipboard_item_service.dart';
import '../services/clipboard_monitor_service.dart';
import '../services/realtime_sync_service.dart';
import '../viewmodels/clipboard_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => ClipboardItemService());
  locator.registerLazySingleton(() => ClipboardMonitorService());
  locator.registerLazySingleton(() => RealtimeSyncService());
  locator.registerFactory(() => ClipboardViewModel(
    clipboardItemService: locator<ClipboardItemService>(),
  ));
}
