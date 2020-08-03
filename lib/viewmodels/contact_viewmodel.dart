import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/viewmodels/base_model.dart';
//import 'package:flutter/foundation.dart';

class ContactViewModel extends BaseModel {
  final ContactServices _contactService = locator<ContactServices>();

  Future getAllContactsFromDevice() async {
    List<String> uploadContacts = List<String>();
    List<MyContact> allContacts = await _contactService.getAllContacts();
    allContacts.forEach((con) {
      uploadContacts.add(con.number);
      DatabaseService.db.insertContact(con);
    });
    return allContacts;
  }

  Future<List<MyContact>> getContactsFromDb() async {
    await getAllContactsFromDevice();
    List<MyContact> allContacts = await DatabaseService.db.getContactsFromDb();
    return allContacts;
  }
}
