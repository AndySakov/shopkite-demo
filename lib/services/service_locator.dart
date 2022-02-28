import 'package:get_it/get_it.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shopkite_demo/services/api_service.dart';
import 'package:shopkite_demo/services/db_service.dart';
import 'package:shopkite_demo/services/printer_service.dart';

final serviceLocator = GetIt.instance;

setupServiceLocators() {
  serviceLocator.registerLazySingleton<DbService>(() => DbService.instance);
  serviceLocator
      .registerLazySingleton<PrinterService>(() => PrinterService.instance);
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService.instance);
  serviceLocator.registerLazySingleton<NfcManager>(() => NfcManager.instance);
}
