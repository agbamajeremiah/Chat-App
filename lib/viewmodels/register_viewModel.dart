import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:flutter/foundation.dart';

import 'package:stacked/stacked.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    @required String phoneNumber,
  }) async {
    setBusy(true);
    var resposnse =
        await _authenticationSerivice.register(phoneNumber: phoneNumber);
    print(resposnse);
    _navigationService.navigateTo(OtpViewRoute, arguments: phoneNumber);
    setBusy(false);
  }
}
