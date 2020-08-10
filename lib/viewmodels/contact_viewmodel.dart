import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/viewmodels/base_model.dart';

class ContactViewModel extends BaseModel {
  //Fetch all registered contacts from database
  Future<List<MyContact>> getContactsFromDb() async {
    List<MyContact> allContacts = await DatabaseService.db.getContactsFromDb();
    return allContacts;
  }
}
