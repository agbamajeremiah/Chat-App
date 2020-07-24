import 'package:MSG/models/user.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/ui/widgets/single_search_contact.dart';
import 'package:MSG/ui/widgets/single_contact.dart';
import 'package:flutter/material.dart';

class AllContacts extends StatefulWidget {
  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  final TextEditingController _searchTextCon = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  int contactsCount = allContacts.length;
  final regContacts = allContacts;
  @override
  void initState() {
    super.initState();
    _searchTextCon.addListener(() {
      setState(() {
        _searchQuery = _searchTextCon.text;
      });
    });
  }

  @override
  void dispose() {
    _searchTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultList = _searchQuery.isEmpty
        ? null
        : regContacts
            .where((p) => p.displayName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: (_isSearching)
            ? AppBar(
                iconTheme: IconThemeData(
                  color: AppColors.textColor,
                ),
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchQuery = "";
                      });
                    },
                    icon: Icon(Icons.arrow_back)),
                title: Container(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      // override textfield's icon color when selected
                      primaryColor: AppColors.textColor,
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: _searchTextCon,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15.0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Search...",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchTextCon.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : AppBar(
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
                      style: textStyle.copyWith(
                          color: AppColors.textColor, fontSize: 20),
                    ),
                    Text(
                      "${contactsCount.toString()} Contacts",
                      style: textStyle.copyWith(
                          color: AppColors.textColor, fontSize: 12),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    icon: Icon(Icons.search),
                  ),
                  MyPopupMenu(),
                ],
              ),
        body: Container(
          child: _searchQuery.isNotEmpty
              ? Container(
                  //searchResultList
                  child: (searchResultList.length < 1)
                      ? Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("No Contact Found!"),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResultList.length,
                          itemBuilder: (context, index) {
                            final item = searchResultList[index];
                            return SearchContact(
                              contactName: item.displayName.toString(),
                              number: item.mobileNumber,
                              matchString: _searchQuery,
                            );
                          },
                        ),
                )
              : Container(
                  child: ListView.builder(
                    itemCount: regContacts.length,
                    itemBuilder: (context, index) {
                      final item = regContacts[index];
                      return SingleContact(
                          name: item.displayName.toString(),
                          number: item.mobileNumber.toString());
                    },
                  ),
                ),
        ));
  }
}
