import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class UpdateProvfileViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future updateProfile({
    @required String name,
  }) async {
    try {
      setBusy(true);
      var resposnse = await _authenticationSerivice.updateProfile(name: name);
      print(resposnse);
      _navigationService.navigateTo(WelcomeViewRoute);
      setBusy(false);
    } catch (e) {
      print(e.message);
      setBusy(false);
    }
  }
}
