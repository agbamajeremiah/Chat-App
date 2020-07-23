import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/single_contact.dart';
import 'package:flutter/material.dart';

class AllContacts extends StatefulWidget {
  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  int regContacts = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.textColor,
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Select Contact",
              style:
                  textStyle.copyWith(color: AppColors.textColor, fontSize: 20),
            ),
            Text(
              "${regContacts.toString()} Contacts",
              style:
                  textStyle.copyWith(color: AppColors.textColor, fontSize: 12),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          children: <Widget>[
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
            SingleContact(number: "+2348063753133"),
          ],
        ),
      ),
    );
  }
}
