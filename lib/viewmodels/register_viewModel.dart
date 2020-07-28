import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class RegisterViewModel extends BaseModel {
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
    _navigationService.navigateTo(OtpViewRoute);
    setBusy(false);
  }
}
