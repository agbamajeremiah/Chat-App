import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DatabaseService);
  locator.registerLazySingleton(() => AuthenticationSerivice());
  locator.registerLazySingleton(() => ContactServices());
}
