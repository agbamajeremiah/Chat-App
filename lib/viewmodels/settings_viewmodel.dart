import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/counter_service.dart';
// import 'package:MSG/viewmodels/base_model.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  // String get profileName;
  String get accountName => _authenticationSerivice.profileName;

  final _counterService = locator<CounterService>();
  int get count => _counterService.counter;
  void doubleIncrementCount() {
    _counterService.doubleIncrementCounter();
    notifyListeners();
  }
}
