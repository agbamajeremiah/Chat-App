import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class OTPViewModel extends BaseModel {
  String verifyMessage;
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future verify({
    @required String code,
  }) async {
    setBusy(true);
    var response = await _authenticationSerivice.verifyOTP(otp: code);
    _navigationService.navigateTo(UpdateProfileRoute);
    setBusy(false);
  }

  Future resendOTP({
    @required String phoneNumber,
  }) async {
    await _authenticationSerivice.resentOTP(phoneNumber: phoneNumber);
  }
}
