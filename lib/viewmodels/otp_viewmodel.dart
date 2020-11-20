import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart';

class OTPViewModel extends BaseViewModel {
  String verifyMessage;
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future verify({
    @required String code,
  }) async {
    setBusy(true);
    var response = await _authenticationSerivice.verifyOTP(otp: code);
    if (response == 200) {
      _navigationService.navigateTo(UpdateProfileRoute);
    } else {
      return response;
    }
    setBusy(false);
  }

  Future resendOTP({
    @required String phoneNumber,
  }) async {
    await _authenticationSerivice.resentOTP(phoneNumber: phoneNumber);
  }
}
