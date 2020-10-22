import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/messaging_sync_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class UpdateProvfileViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();
  final MessagingServices _messageService = locator<MessagingServices>();

  Future updateProfile({
    @required String name,
  }) async {
    setBusy(true);
    try {
      var resposnse = await _authenticationSerivice.updateProfile(name: name);
      print(resposnse);
      await synFirstTime().then((value) =>
          _navigationService.removeAllAndNavigateTo(MessageViewRoute));
    } catch (e) {
      print(e.message);
    }
    setBusy(false);
  }

  Future synFirstTime() async {
    try {
      await _authenticationSerivice.setNumber();
      await _messageService.getSyncChats();
      await _contactService.firstSyncContacts();
    } catch (e) {
      print(e.toString());
    }
  }
}
