import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class UpdateProvfileViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();

  Future updateProfile({
    @required String name,
  }) async {
    try {
      setBusy(true);
      var resposnse = await _authenticationSerivice.updateProfile(name: name);
      print(resposnse);
      try {
        await _contactService.syncContacts();
      } catch (e) {
        print(e.toString());
      }
      _navigationService.navigateTo(MessageViewRoute);
      setBusy(false);
    } catch (e) {
      print(e.message);
      setBusy(false);
    }
  }
}
