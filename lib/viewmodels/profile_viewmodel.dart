import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class ProfileViewModel extends BaseModel {
  String newAccountName = "";
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();

  Future updateProfileName({
    @required String name,
  }) async {
    setBusy(true);
    try {
      var resposnse = await _authenticationSerivice.updateProfile(name: name);
      print(resposnse);
    } catch (e) {
      print(e.message);
    }
    setBusy(false);
  }
}
