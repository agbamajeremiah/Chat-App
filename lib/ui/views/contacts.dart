import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/widgets/single_contact.dart';
import 'package:MSG/viewmodels/contact_viewmodel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AllContacts extends StatefulWidget {
  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts>
    with SingleTickerProviderStateMixin {
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
    final themeData = Theme.of(context);
    return ViewModelBuilder<ContactViewModel>.reactive(
        disposeViewModel: true,
        viewModelBuilder: () => ContactViewModel(),
        builder: (context, model, snapshot) {
          //model.syncContacts();
          return FutureBuilder(
            future: model.getContactsFromDb(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
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
                    appBar: (_isSearching)
                        ? AppBar(
                            leading: IconButton(
                                onPressed: () {
                                  _searchTextCon.clear();
                                  setState(() {
                                    _isSearching = false;
                                    _searchQuery = "";
                                  });
                                },
                                icon: Icon(Icons.arrow_back)),
                            title: AnimatedContainer(
                              duration: Duration(microseconds: 300),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  // override textfield's icon color when selected
                                  primaryColor: AppColors.textColor,
                                ),
                                child: TextField(
                                  autofocus: true,
                                  controller: _searchTextCon,
                                  style: themeData.textTheme.bodyText1.copyWith(
                                    fontSize: 18.0,
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
                                      icon: Icon(Icons.clear,
                                          color: themeData.iconTheme.color),
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
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Select Contact",
                                  style: themeData.textTheme.bodyText1
                                      .copyWith(fontSize: 20),
                                ),
                                Text(
                                  "${contactsCount.toString()} Contacts",
                                  style: themeData.textTheme.bodyText1
                                      .copyWith(fontSize: 12.5),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              model.refreshingContacts
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: SpinKitRing(
                                        color: themeData.iconTheme.color,
                                        lineWidth: 2.0,
                                        size: 20.0,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = true;
                                        });
                                      },
                                      icon: Icon(Icons.search),
                                    ),
                              PopupMenuButton<String>(
                                  color: themeData.backgroundColor,
                                  icon: Icon(
                                    Icons.more_vert,
                                  ),
                                  onSelected: (option) {
                                    switch (option) {
                                      case "refresh":
                                        print("refresh contacts");
                                        model.syncContacts();
                                        break;
                                      case "settings":
                                        print("Switch to Settings");
                                        Navigator.pushNamed(
                                            context, SettingsViewRoute);
                                        break;
                                      case "help":
                                        print("Switch to Help Screen");
                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem(
                                        child: Text("Refresh"),
                                        value: "refresh",
                                        textStyle: themeData.textTheme.bodyText1
                                            .copyWith(fontSize: 13.5),
                                      ),
                                      PopupMenuDivider(
                                        height: 2,
                                      ),
                                      PopupMenuItem(
                                        child: Text("Settings"),
                                        value: "settings",
                                        textStyle: themeData.textTheme.bodyText1
                                            .copyWith(fontSize: 13.5),
                                      ),
                                      PopupMenuDivider(
                                        height: 2,
                                      ),
                                      PopupMenuItem(
                                        child: Text("Help"),
                                        textStyle: themeData.textTheme.bodyText1
                                            .copyWith(fontSize: 13.5),
                                        value: "help",
                                      ),
                                    ];
                                  })
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
                                        child: Text("No Contact Found!",
                                            style: themeData.textTheme.bodyText1
                                                .copyWith(fontSize: 15)),
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
                                                          style: themeData
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontSize:
                                                                      17.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                                  style: themeData
                                                      .textTheme.bodyText1
                                                      .copyWith(
                                                          fontSize: 17.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          : index < regContacts.length
                                              ? SingleContact(
                                                  name:
                                                      item.fullName.toString(),
                                                  number: item.phoneNumber
                                                      .toString(),
                                                  searching: false,
                                                  registered: true,
                                                )
                                              : SingleContact(
                                                  name:
                                                      item.fullName.toString(),
                                                  number: item.phoneNumber
                                                      .toString(),
                                                  searching: false,
                                                  registered: false,
                                                );
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
    // _animationController.dispose();
    super.dispose();
  }
}
