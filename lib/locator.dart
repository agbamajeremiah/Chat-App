import 'package:MSG/core/network/network_info.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/download_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/services/message_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DatabaseService);
  locator.registerLazySingleton(() => AuthenticationSerivice());
  locator.registerLazySingleton(() => ContactServices());
  locator.registerLazySingleton(() => SocketServices());
  locator.registerLazySingleton(() => MessageService());
  locator.registerLazySingleton(() => DownloadService());
  locator.registerLazySingleton(() => NetworkInfo());
}
