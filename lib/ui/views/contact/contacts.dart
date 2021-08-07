import 'package:MSG/models/contacts.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/widgets/contact_popup.dart';
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
          return FutureBuilder(
            future: model.getContactsFromDb(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: AppColors.bgGrey,
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
                return Scaffold(
                  backgroundColor: AppColors.bgGrey,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(65.0),
                    child: (_isSearching)
                        ? AppBar(
                            backgroundColor: AppColors.bgGrey,
                            elevation: 0.0,
                            leading: IconButton(
                                onPressed: () {
                                  _searchTextCon.clear();
                                  setState(() {
                                    _isSearching = false;
                                    _searchQuery = "";
                                  });
                                },
                                icon: Icon(Icons.arrow_back,
                                    color: AppColors.primaryColor)),
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
                                          color: AppColors.primaryColor),
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
                            backgroundColor: AppColors.bgGrey,
                            elevation: 0.0,
                            leading: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25.0,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Select Contact",
                                  style: themeData.textTheme.headline6.copyWith(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${contactsCount.toString()} Contacts",
                                  style: themeData.textTheme.headline6.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal),
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
                                      icon: Icon(
                                        Icons.search,
                                      ),
                                    ),
                              ContactPopupMenu(synContact: model.synContacts),
                            ],
                          ),
                  ),
                  body: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: _searchQuery.isNotEmpty
                          ? Container(
                              //searchRegList
                              child: (searchRegList.length < 1 &&
                                      searchUnRegList.length < 1)
                                  ? Container(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text("No contact found!",
                                            style: themeData.textTheme.bodyText1
                                                .copyWith(fontSize: 17.5)),
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
                                                                horizontal: 30,
                                                                vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                              child: Icon(
                                                                  Icons
                                                                      .sms_outlined,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 20.0),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Invite Friends",
                                                                style: themeData
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .copyWith(
                                                                        fontSize:
                                                                            17.5,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : index < searchRegList.length
                                                      ? SingleContact(
                                                          name: item.fullName
                                                              .toString(),
                                                          number:
                                                              item.phoneNumber,
                                                          searching: true,
                                                          registered: true,
                                                          matchString:
                                                              _searchQuery,
                                                          pictureUrl: item
                                                              .profilePictureUrl,
                                                          picturePath: item
                                                              .profilePicturePath,
                                                          pictureDownloaded: item
                                                              .pictureDownloaded,
                                                        )
                                                      : SingleContact(
                                                          name: item.fullName
                                                              .toString(),
                                                          number:
                                                              item.phoneNumber,
                                                          searching: true,
                                                          registered: false,
                                                          matchString:
                                                              _searchQuery,
                                                          pictureUrl: item
                                                              .profilePictureUrl,
                                                          picturePath: item
                                                              .profilePicturePath,
                                                          pictureDownloaded: item
                                                              .pictureDownloaded,
                                                        );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                          : (regContacts.length < 1 && unregContacts.length < 1)
                              ? Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text("No contact found!",
                                        style: themeData.textTheme.bodyText1
                                            .copyWith(fontSize: 17.5)),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        itemCount: regContacts.length +
                                            unregContacts.length +
                                            1,
                                        itemBuilder: (context, index) {
                                          final item = index <
                                                  regContacts.length
                                              ? regContacts[index]
                                              : index == regContacts.length
                                                  ? null
                                                  : unregContacts[index -
                                                      (regContacts.length + 1)];

                                          return index == regContacts.length
                                              ? Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5.0),
                                                          child: Icon(
                                                              Icons
                                                                  .sms_outlined,
                                                              color:
                                                                  Colors.black,
                                                              size: 20.0),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
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
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : index < regContacts.length
                                                  ? SingleContact(
                                                      name: item.fullName
                                                          .toString(),
                                                      number: item.phoneNumber
                                                          .toString(),
                                                      searching: false,
                                                      registered: true,
                                                      pictureUrl: item
                                                          .profilePictureUrl,
                                                      picturePath: item
                                                          .profilePicturePath,
                                                      pictureDownloaded: item
                                                          .pictureDownloaded,
                                                    )
                                                  : SingleContact(
                                                      name: item.fullName
                                                          .toString(),
                                                      number: item.phoneNumber
                                                          .toString(),
                                                      searching: false,
                                                      registered: false,
                                                      pictureUrl: item
                                                          .profilePictureUrl,
                                                      picturePath: item
                                                          .profilePicturePath,
                                                      pictureDownloaded: item
                                                          .pictureDownloaded,
                                                    );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
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
