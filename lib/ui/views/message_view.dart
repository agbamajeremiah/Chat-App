import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/viewmodels/message_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _searchTextCon = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  bool rebuild = false;
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
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ViewModelBuilder<MessageViewModel>.reactive(
        disposeViewModel: true,
        viewModelBuilder: () => MessageViewModel(),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, snapshot) {
          // print(model.busy.toString());
          return FutureBuilder(
            future: model.getAllChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: themeData.backgroundColor,
                );
              } else {
                List<Chat> allChats = snapshot.data;
                final chatCount = allChats.length;
                final searchChatList = _searchTextCon.text.isEmpty
                    ? []
                    : allChats
                        .where((ch) =>
                            ch.displayName.contains(new RegExp(_searchQuery,
                                caseSensitive: false)) ||
                            ch.lastMessage.contains(
                                new RegExp(_searchQuery, caseSensitive: false)))
                        .toList();

                return Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) {
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarColor: notifier.darkTheme
                          ? AppColors.darkBgColor
                          : Colors.white,
                      statusBarBrightness: notifier.darkTheme
                          ? Brightness.dark
                          : Brightness.light,
                      statusBarIconBrightness: notifier.darkTheme
                          ? Brightness.light
                          : Brightness.dark,
                      systemNavigationBarColor:
                          notifier.darkTheme ? Colors.black : Colors.white,
                    ),
                    child: SafeArea(
                      child: Scaffold(
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            var refresh = await Navigator.pushNamed(
                                context, ContactViewRoute);
                            print("page rebuilt");
                            setState(() => rebuild = refresh);
                          },
                          child: Icon(
                            Icons.message,
                          ),
                        ),
                        appBar: (_isSearching)
                            ? AppBar(
                                iconTheme: themeData.iconTheme,
                                backgroundColor: themeData.appBarTheme.color,
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchTextCon.clear();
                                      _isSearching = false;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_back),
                                ),
                                title: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  child: TextField(
                                    autofocus: true,
                                    controller: _searchTextCon,
                                    style:
                                        themeData.textTheme.bodyText1.copyWith(
                                      fontSize: 18.0,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintStyle: themeData
                                          .inputDecorationTheme.hintStyle,
                                      hintText: "Search...",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear,
                                            color: themeData.iconTheme.color),
                                        onPressed: () {
                                          print(_searchTextCon.text);
                                          _searchTextCon.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : AppBar(
                                backgroundColor: themeData.appBarTheme.color,
                                title: Text("Messeges",
                                    style: themeData.textTheme.headline6),
                                centerTitle: true,
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
                        body: SafeArea(
                            child: chatCount > 0
                                ? _searchQuery.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        child: ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          itemCount: chatCount,
                                          itemBuilder: (context, index) {
                                            final chat = allChats[index];
                                            print("member:");
                                            return InkWell(
                                              onTap: () async {
                                                var refresh =
                                                    await Navigator.pushNamed(
                                                        context, ChatViewRoute,
                                                        arguments: {
                                                      'chat': Chat(
                                                          id: chat.id,
                                                          displayName:
                                                              chat.displayName,
                                                          memberPhone:
                                                              chat.memberPhone),
                                                      'fromContact': false
                                                    });

                                                // print(refresh);
                                                setState(
                                                    () => rebuild = refresh);
                                              },
                                              child: MessageContainer(
                                                  searchquery: "",
                                                  name: chat.displayName ??
                                                      chat.memberPhone,
                                                  lastMessage: chat.lastMessage,
                                                  msgTime: chat.lastMsgTime,
                                                  unreadMessages:
                                                      chat.unreadMsgCount),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Divider(
                                              thickness: 0.4,
                                              color: themeData.dividerColor,
                                            );
                                          },
                                        ),
                                      )
                                    : searchChatList.length > 0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            child: ListView.separated(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              itemCount: searchChatList.length,
                                              itemBuilder: (context, index) {
                                                final chat =
                                                    searchChatList[index];
                                                print("member:");
                                                return InkWell(
                                                  onTap: () {
                                                    _searchTextCon.clear();
                                                    _isSearching = false;
                                                    Navigator.pushNamed(
                                                        context, ChatViewRoute,
                                                        arguments: Chat(
                                                            id: chat.id,
                                                            displayName: chat
                                                                .displayName,
                                                            memberPhone: chat
                                                                .memberPhone));
                                                  },
                                                  child: MessageContainer(
                                                    searchquery: _searchQuery,
                                                    name: chat.displayName ??
                                                        chat.memberPhone,
                                                    lastMessage:
                                                        chat.lastMessage,
                                                    msgTime: chat.lastMsgTime,
                                                    unreadMessages:
                                                        chat.unreadMsgCount,
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider();
                                              },
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text("No Match Found!",
                                                  style: themeData
                                                      .textTheme.bodyText1
                                                      .copyWith(fontSize: 15)),
                                            ),
                                          )
                                : Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Align(
                                      child: Text(
                                        "No conversation yet",
                                        style: themeData.textTheme.bodyText1
                                            .copyWith(fontSize: 15.0),
                                      ),
                                    ),
                                  )),
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
