import 'package:MSG/models/contacts.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/ui/widgets/single_contact.dart';
import 'package:MSG/viewmodels/contact_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class AllContacts extends StatefulWidget {
  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  final TextEditingController _searchTextCon = TextEditingController();
  //GlobalKey<RefreshIndicatorState> _refreshKey;
  bool _isSearching = false;
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    // _refreshKey = GlobalKey<RefreshIndicatorState>();
    _searchTextCon.addListener(() {
      setState(() {
        _searchQuery = _searchTextCon.text;
      });
    });
  }

  // void _refreshContacts() {}
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ContactViewModel>.withConsumer(
        viewModelBuilder: () => ContactViewModel(),
        builder: (context, model, snapshot) {
          final myContactList = model.getContactsFromDb();
          model.syncContacts();

          return FutureBuilder(
            future: myContactList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.textColor),
                  )),
                );
              } else {
                Map<String, List<MyContact>> allContacts = snapshot.data;
                List<MyContact> regContacts = allContacts['registeredContacts'];
                List<MyContact> unregContacts =
                    allContacts['unregisteredContacs'];
                final contactsCount = regContacts.length;
                final searchRegList = _searchQuery.isEmpty
                    ? null
                    : regContacts
                        .where((p) => p.fullName
                            .toLowerCase()
                            .startsWith(_searchQuery.toLowerCase()))
                        .toList();
                final searchUnRegList = _searchQuery.isEmpty
                    ? null
                    : unregContacts
                        .where((p) => p.fullName
                            .toLowerCase()
                            .startsWith(_searchQuery.toLowerCase()))
                        .toList();
                //print(regContacts);
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: (_isSearching)
                        ? AppBar(
                            iconTheme: IconThemeData(
                              color: AppColors.textColor,
                            ),
                            backgroundColor: Colors.white,
                            leading: IconButton(
                                onPressed: () {
                                  _searchTextCon.clear();
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
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
                              //searchRegList
                              child: (searchRegList.length < 1 &&
                                      searchUnRegList.length < 1)
                                  ? Container(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text("No Contact Found!"),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            itemCount: searchRegList.length +
                                                searchUnRegList.length +
                                                1,
                                            itemBuilder: (context, index) {
                                              final item = index <
                                                      searchRegList.length
                                                  ? searchRegList[index]
                                                  : index ==
                                                          searchRegList.length
                                                      ? null
                                                      : searchUnRegList[index -
                                                          (searchRegList
                                                                  .length +
                                                              1)];
                                              return index ==
                                                      searchRegList.length
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Text(
                                                          "Invite Friends",
                                                          style: textStyle.copyWith(
                                                              fontSize: 17,
                                                              color: AppColors
                                                                  .textColor2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : SingleContact(
                                                      name: item.fullName
                                                          .toString(),
                                                      number: item.phoneNumber,
                                                      searching: true,
                                                      matchString: _searchQuery,
                                                    );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    itemCount: regContacts.length +
                                        unregContacts.length +
                                        1,
                                    itemBuilder: (context, index) {
                                      print(contactsCount);
                                      print(index);
                                      final item = index < regContacts.length
                                          ? regContacts[index]
                                          : index == regContacts.length
                                              ? null
                                              : unregContacts[index -
                                                  (regContacts.length + 1)];

                                      return index == regContacts.length
                                          ? Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                child: Text(
                                                  "Invite Friends",
                                                  style: textStyle.copyWith(
                                                      fontSize: 17,
                                                      color:
                                                          AppColors.textColor2,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : SingleContact(
                                              name: item.fullName.toString(),
                                              number:
                                                  item.phoneNumber.toString(),
                                              searching: false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              }
            },
          );
        });
  }

  @override
  void dispose() {
    _searchTextCon.dispose();
    super.dispose();
  }
}
/*
  BusyButton(
                        title: "Continue",
                        busy: model.busy,
                        onPressed: () async {
                          // print(prefix + phoneNumber.text);
                          await model.login(
                              phoneNumber: prefix + phoneNumber.text);
                        },
                        color: Colors.blue)
                  ],
                  
                  
                  
                  
                  
*/
