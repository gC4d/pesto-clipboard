import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../viewmodels/clipboard_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerFactory(() => ClipboardViewModel(apiService: locator<ApiService>()));
}
