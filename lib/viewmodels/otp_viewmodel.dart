import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class OTPViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future verify({
    @required String code,
  }) async {
    try {
      setBusy(true);
      var resposnse = await _authenticationSerivice.verifyOTP(otp: code);
      print(resposnse);
      _navigationService.navigateTo(OtpViewRoute);
      setBusy(false);
    } catch (e) {}
  }
}
