import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class ProfileViewModel extends BaseModel {
  String newAccountName = "";
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  // String get profileName;
  String get userNumber => _authenticationSerivice.userNumber;
  String get accountName => _authenticationSerivice.profileName;

  Future updateProfileName({
    @required String name,
  }) async {
    setBusy(true);
    try {
      await _authenticationSerivice
          .updateProfile(name: name)
          .whenComplete(() => _authenticationSerivice.setNewName());
      return true;
    } catch (e) {
      print(e.message);
    }
    setBusy(false);
  }
}
