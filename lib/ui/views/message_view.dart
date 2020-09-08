import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
//import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/viewmodels/message_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _searchTextCon = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //       statusBarColor: Colors.white,
    //       statusBarIconBrightness: Brightness.dark),
    // );
    _searchTextCon.addListener(() {
      setState(() {
        _searchQuery = _searchTextCon.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessageViewModel>.withConsumer(
        viewModelBuilder: () => MessageViewModel(),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, snapshot) {
          model.syncChat();
          return FutureBuilder(
            future: model.getAllChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: Colors.white,
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

                return Scaffold(
                  backgroundColor: Colors.white,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ContactViewRoute);
                    },
                    child: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
                  appBar: (_isSearching)
                      ? AppBar(
                          iconTheme: IconThemeData(
                            color: AppColors.textColor,
                          ),
                          backgroundColor: Colors.white,
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchTextCon.clear();
                                  _isSearching = false;
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
                                      print(_searchTextCon.text);
                                      _searchTextCon.clear();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : AppBar(
                          elevation: 2,
                          backgroundColor: Colors.white,
                          title: Text(
                            "Messeges",
                            style: textStyle.copyWith(
                                color: AppColors.textColor, fontSize: 22),
                          ),
                          centerTitle: true,
                          actions: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                              icon: Icon(Icons.search),
                              color: AppColors.textColor,
                            ),
                            MyPopupMenu(),
                          ],
                        ),
                  body: SafeArea(
                      child: chatCount > 0
                          ? _searchQuery.isEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0.0),
                                  child: ListView.separated(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    itemCount: chatCount,
                                    itemBuilder: (context, index) {
                                      final chat = allChats[index];
                                      print("member:");
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, ChatViewRoute,
                                              arguments: Chat(
                                                  id: chat.id,
                                                  displayName: chat.displayName,
                                                  memberPhone:
                                                      chat.memberPhone));
                                        },
                                        child: MessageContainer(
                                          searchquery: "",
                                          name: chat.displayName ??
                                              chat.memberPhone,
                                          lastMessage: chat.lastMessage,
                                          msgTime: chat.lastMsgTime,
                                          isNotRead: false,
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(
                                        color: Colors.grey,
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
                                          final chat = searchChatList[index];
                                          print("member:");
                                          return InkWell(
                                            onTap: () {
                                              _searchTextCon.clear();
                                              _isSearching = false;
                                              Navigator.pushNamed(
                                                  context, ChatViewRoute,
                                                  arguments: Chat(
                                                      id: chat.id,
                                                      displayName:
                                                          chat.displayName,
                                                      memberPhone:
                                                          chat.memberPhone));
                                            },
                                            child: MessageContainer(
                                              searchquery: _searchQuery,
                                              name: chat.displayName ??
                                                  chat.memberPhone,
                                              lastMessage: chat.lastMessage,
                                              msgTime: chat.lastMsgTime,
                                              isNotRead: false,
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text("No Match Found!"),
                                      ),
                                    )
                          : Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Align(
                                child: Text(
                                  "No conversation yet",
                                  style: textStyle.copyWith(
                                      color: AppColors.textColor,
                                      fontSize: 14.0),
                                ),
                              ),
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
