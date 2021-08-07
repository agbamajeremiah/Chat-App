import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  // String get profileName;
  String get accountName => _authenticationSerivice.profileName;
}
