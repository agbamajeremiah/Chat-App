import 'dart:math';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/widgets/linear_progress_bar.dart';
import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:MSG/viewmodels/message_viewmodel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class MessagesView extends StatefulWidget {
  final bool firstTime;
  MessagesView({Key key, @required this.firstTime}) : super(key: key);

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView>
    with SingleTickerProviderStateMixin {
  final random = Random();

  TabController _tabController;
  final _searchTextCon = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // initialize _tabController
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    //Add search controller listener
    _searchTextCon.addListener(() {
      setState(() {
        _searchQuery = _searchTextCon.text;
      });
    });
    AwesomeNotifications().dismissAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final vHeight = MediaQuery.of(context).size.height;
    final vWeight = MediaQuery.of(context).size.width;
    return ViewModelBuilder<MessageViewModel>.reactive(
        viewModelBuilder: () => MessageViewModel(isFirstTime: widget.firstTime),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, snapshot) {
          return FutureBuilder(
            future: model.getAllChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return !widget.firstTime
                    ? Scaffold(
                        backgroundColor: AppColors.primaryColor,
                        body: Center(
                          child: Text(
                            "MSG",
                            style: textStyle.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Scaffold(
                        backgroundColor: AppColors.bgGrey,
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Restoring Chats....',
                                style: themeData.textTheme.bodyText1.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25.0,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: vHeight * 0.2,
                            ),
                            Container(
                                child: Align(
                              child: LinearProgressBar(),
                            )),
                            SizedBox(
                              height: vHeight * 0.2,
                            ),
                          ],
                        ),
                      );
              } else {
                List<Chat> allChats = snapshot.data;
                final allChatCount = allChats.length;
                final favChats =
                    allChats.where((ch) => ch.favourite == 1).toList();
                final favChatCount = favChats.length;
                final searchChatList = _searchTextCon.text.isEmpty
                    ? []
                    : allChats
                        .where((ch) =>
                            ch.displayName.contains(new RegExp(
                                escapeSpecial(_searchQuery),
                                caseSensitive: false)) ||
                            ch.lastMessage.contains(new RegExp(
                                escapeSpecial(_searchQuery),
                                caseSensitive: false)))
                        .toList();
                final searchFavChatList = _searchTextCon.text.isEmpty
                    ? []
                    : favChats
                        .where((ch) =>
                            ch.displayName.contains(new RegExp(
                                escapeSpecial(_searchQuery),
                                caseSensitive: false)) ||
                            ch.lastMessage.contains(new RegExp(
                                escapeSpecial(_searchQuery),
                                caseSensitive: false)))
                        .toList();
                return Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) {
                  return WillPopScope(
                    onWillPop: () async {
                      if (_isSearching == true) {
                        setState(() {
                          _searchTextCon.clear();
                          _isSearching = false;
                        });
                        return false;
                      } else {
                        return true;
                      }
                    },
                    child: AnnotatedRegion(
                      value: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.dark,
                          statusBarIconBrightness: Brightness.light),
                      child: Scaffold(
                        backgroundColor: AppColors.primaryColor,
                        floatingActionButton: !_isSearching
                            ? FloatingActionButton(
                                //                           onPressed: () async{
                                //                             final int notificationId = random.nextInt(1000000);
                                // await AwesomeNotifications().createNotification(
                                //   content: NotificationContent(
                                //     id: notificationId,
                                //     channelKey: 'private_msg_channel',
                                //     title: "test title",
                                //     body: "test Body",
                                //     displayedLifeCycle: NotificationLifeCycle.AppKilled,
                                //     showWhen: true,
                                //     autoCancel: true,
                                //     notificationLayout: NotificationLayout.Default,
                                //     payload: {
                                //       // 'threadID': newMessage['threadID'],
                                //       // 'displayName': displayName,
                                //       // 'sender': newMessage['sender'],
                                //     },
                                //   ),
                                // );

                                //                           },
                                onPressed: (() => Navigator.pushNamed(
                                    context, Routes.contactViewRoute)),
                                child: Icon(
                                  Icons.message,
                                ),
                                backgroundColor: AppColors.primaryColor,
                              )
                            : null,
                        body: SafeArea(
                          child: Stack(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0.0),
                                      height:
                                          _isSearching ? 65 : vHeight * 0.16,
                                      color: AppColors.primaryColor,
                                      child: _isSearching
                                          ? Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      size: 25.0,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _searchTextCon.clear();
                                                        _isSearching = false;
                                                      });
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      autofocus: true,
                                                      controller:
                                                          _searchTextCon,
                                                      style: themeData
                                                          .textTheme.bodyText1
                                                          .copyWith(
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20.0),
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        hintStyle: themeData
                                                            .inputDecorationTheme
                                                            .hintStyle
                                                            .copyWith(
                                                                color: Colors
                                                                    .grey),
                                                        hintText: "Search...",
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            Icons.clear,
                                                            size: 25.0,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            _searchTextCon
                                                                .clear();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    "MSG",
                                                    style: themeData
                                                        .textTheme.headline5
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 35,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _isSearching = true;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.search,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      MyPopupMenu(),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: AppColors.bgGrey,
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: allChatCount > 0
                                                  ? _searchQuery.isEmpty
                                                      ? Padding(
                                                          padding: EdgeInsets.only(
                                                              top: _isSearching
                                                                  ? 0.0
                                                                  : 50.0,
                                                              left: 20,
                                                              right: 20),
                                                          child: ListView
                                                              .separated(
                                                            padding: EdgeInsets.only(
                                                                top:
                                                                    _isSearching
                                                                        ? 25.0
                                                                        : 50.0,
                                                                bottom: 10.0),
                                                            itemCount:
                                                                allChatCount,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final chat =
                                                                  allChats[
                                                                      index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      Routes.chatViewRoute,
                                                                      arguments: {
                                                                        'chat':
                                                                            Chat(
                                                                          id: chat
                                                                              .id,
                                                                          displayName:
                                                                              chat.displayName,
                                                                          memberPhone:
                                                                              chat.memberPhone,
                                                                          contactChatID:
                                                                              chat.contactChatID,
                                                                          pictureUrl:
                                                                              chat.pictureUrl,
                                                                          picturePath:
                                                                              chat.picturePath,
                                                                          profilePictureDownloaded:
                                                                              chat.profilePictureDownloaded,
                                                                          favourite:
                                                                              chat.favourite,
                                                                        ),
                                                                        'fromContact':
                                                                            false
                                                                      });
                                                                },
                                                                child:
                                                                    MessageContainer(
                                                                  searchquery:
                                                                      "",
                                                                  name: chat
                                                                      .displayName,
                                                                  number: chat
                                                                      .memberPhone,
                                                                  lastMessage: chat
                                                                      .lastMessage,
                                                                  msgTime: chat
                                                                      .lastMsgTime,
                                                                  unreadMessages:
                                                                      chat.unreadMsgCount,
                                                                  picturePath: chat
                                                                      .picturePath,
                                                                ),
                                                              );
                                                            },
                                                            separatorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 70.0,
                                                                    right:
                                                                        10.0),
                                                                child: Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                  thickness:
                                                                      0.15,
                                                                ),
                                                              );
                                                              // return SizedBox(
                                                              //     height: 15.0);
                                                            },
                                                          ),
                                                        )
                                                      : searchChatList.length >
                                                              0
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: ListView
                                                                  .separated(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            25.0,
                                                                        bottom:
                                                                            10.0),
                                                                itemCount:
                                                                    searchChatList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final chat =
                                                                      searchChatList[
                                                                          index];
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _searchTextCon
                                                                          .clear();
                                                                      _isSearching =
                                                                          false;
                                                                      Navigator
                                                                          .pushNamed(
                                                                        context,
                                                                        Routes.chatViewRoute,
                                                                        arguments: {
                                                                          'chat':
                                                                              Chat(
                                                                            id: chat.id,
                                                                            displayName:
                                                                                chat.displayName,
                                                                            memberPhone:
                                                                                chat.memberPhone,
                                                                            contactChatID:
                                                                                chat.contactChatID,
                                                                            pictureUrl:
                                                                                chat.pictureUrl,
                                                                            picturePath:
                                                                                chat.picturePath,
                                                                            profilePictureDownloaded:
                                                                                chat.profilePictureDownloaded,
                                                                            favourite:
                                                                                chat.favourite,
                                                                          ),
                                                                          'fromContact':
                                                                              false
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        MessageContainer(
                                                                      searchquery:
                                                                          _searchQuery,
                                                                      name: chat
                                                                          .displayName,
                                                                      number: chat
                                                                          .memberPhone,
                                                                      lastMessage:
                                                                          chat.lastMessage,
                                                                      msgTime: chat
                                                                          .lastMsgTime,
                                                                      unreadMessages:
                                                                          chat.unreadMsgCount,
                                                                      picturePath:
                                                                          chat.picturePath,
                                                                    ),
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return SizedBox(
                                                                      height:
                                                                          15.0);
                                                                },
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          25.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child: Text(
                                                                    "No Match Found!",
                                                                    style: themeData
                                                                        .textTheme
                                                                        .bodyText1
                                                                        .copyWith(
                                                                            fontSize:
                                                                                17)),
                                                              ),
                                                            )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 50.0,
                                                          left: 20,
                                                          right: 20),
                                                      child: Align(
                                                        child: Text(
                                                          "No conversation yet",
                                                          style: themeData
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontSize:
                                                                      20.0),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            //Favourite chats
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: favChatCount > 0
                                                  ? _searchQuery.isEmpty
                                                      ? Padding(
                                                          padding: EdgeInsets.only(
                                                              top: _isSearching
                                                                  ? 0.0
                                                                  : 50.0,
                                                              left: 20,
                                                              right: 20),
                                                          child: ListView
                                                              .separated(
                                                            padding: EdgeInsets.only(
                                                                top:
                                                                    _isSearching
                                                                        ? 25.0
                                                                        : 50.0,
                                                                bottom: 10.0),
                                                            itemCount:
                                                                favChats.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final chat =
                                                                  favChats[
                                                                      index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      Routes.chatViewRoute,
                                                                      arguments: {
                                                                        'chat':
                                                                            Chat(
                                                                          id: chat
                                                                              .id,
                                                                          displayName:
                                                                              chat.displayName,
                                                                          memberPhone:
                                                                              chat.memberPhone,
                                                                          contactChatID:
                                                                              chat.contactChatID,
                                                                          pictureUrl:
                                                                              chat.pictureUrl,
                                                                          picturePath:
                                                                              chat.picturePath,
                                                                          profilePictureDownloaded:
                                                                              chat.profilePictureDownloaded,
                                                                          favourite:
                                                                              chat.favourite,
                                                                        ),
                                                                        'fromContact':
                                                                            false
                                                                      });
                                                                },
                                                                child:
                                                                    MessageContainer(
                                                                  searchquery:
                                                                      "",
                                                                  name: chat
                                                                      .displayName,
                                                                  number: chat
                                                                      .memberPhone,
                                                                  lastMessage: chat
                                                                      .lastMessage,
                                                                  msgTime: chat
                                                                      .lastMsgTime,
                                                                  unreadMessages:
                                                                      chat.unreadMsgCount,
                                                                  picturePath: chat
                                                                      .picturePath,
                                                                ),
                                                              );
                                                            },
                                                            separatorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return SizedBox(
                                                                  height: 15.0);
                                                            },
                                                          ),
                                                        )
                                                      : searchFavChatList
                                                                  .length >
                                                              0
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: ListView
                                                                  .separated(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            25.0,
                                                                        bottom:
                                                                            10.0),
                                                                itemCount:
                                                                    searchFavChatList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final chat =
                                                                      searchFavChatList[
                                                                          index];

                                                                  return InkWell(
                                                                    onTap: () {
                                                                      _searchTextCon
                                                                          .clear();
                                                                      _isSearching =
                                                                          false;
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          Routes.chatViewRoute,
                                                                          arguments: {
                                                                            'chat':
                                                                                Chat(
                                                                              id: chat.id,
                                                                              displayName: chat.displayName,
                                                                              memberPhone: chat.memberPhone,
                                                                              contactChatID: chat.contactChatID,
                                                                              pictureUrl: chat.pictureUrl,
                                                                              profilePictureDownloaded: chat.profilePictureDownloaded,
                                                                              picturePath: chat.picturePath,
                                                                              favourite: chat.favourite,
                                                                            ),
                                                                            'fromContact':
                                                                                false
                                                                          });
                                                                    },
                                                                    child:
                                                                        MessageContainer(
                                                                      searchquery:
                                                                          _searchQuery,
                                                                      name: chat
                                                                          .displayName,
                                                                      number: chat
                                                                          .memberPhone,
                                                                      lastMessage:
                                                                          chat.lastMessage,
                                                                      msgTime: chat
                                                                          .lastMsgTime,
                                                                      unreadMessages:
                                                                          chat.unreadMsgCount,
                                                                      picturePath:
                                                                          chat.picturePath,
                                                                    ),
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return SizedBox(
                                                                      height:
                                                                          15.0);
                                                                },
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          25.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child: Text(
                                                                    "No Match Found!",
                                                                    style: themeData
                                                                        .textTheme
                                                                        .bodyText1
                                                                        .copyWith(
                                                                            fontSize:
                                                                                17)),
                                                              ),
                                                            )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 50.0,
                                                          left: 20,
                                                          right: 20),
                                                      child: Align(
                                                        child: Text(
                                                          "No favorite chat",
                                                          style: themeData
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontSize:
                                                                      20.0),
                                                        ),
                                                      ),
                                                    ),
                                            ),

                                            // Work Chats
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50.0,
                                                  left: 20,
                                                  right: 20),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 15),
                                                child: Align(
                                                  child: Text(
                                                    "No Work chat",
                                                    style: themeData
                                                        .textTheme.bodyText1
                                                        .copyWith(
                                                            fontSize: 20.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              !_isSearching
                                  ? Positioned(
                                      top: vHeight * 0.12,
                                      width: vWeight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          height: 120,
                                          width: vWeight,
                                          color: Colors.white,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: TabBar(
                                                controller: _tabController,
                                                indicatorWeight: 0.1,
                                                isScrollable: true,
                                                labelPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                labelColor:
                                                    AppColors.primaryColor,
                                                unselectedLabelColor:
                                                    Colors.grey,
                                                labelStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                tabs: [
                                                  Tab(
                                                    text: 'All',
                                                  ),
                                                  Tab(
                                                    text: 'Favourites',
                                                  ),
                                                  Tab(
                                                    text: 'Work',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
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
