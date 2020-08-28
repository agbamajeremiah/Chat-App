import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
//import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/viewmodels/message_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider_architecture/provider_architecture.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _searchTextCon = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessageViewModel>.withConsumer(
        viewModelBuilder: () => MessageViewModel(),
        //onModelReady: (model) => model.initialise(),
        builder: (context, model, snapshot) {
          return FutureBuilder(
            future: model.getAllChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  )),
                );
              } else {
                List<Chat> allChats = snapshot.data;
                final chatCount = allChats.length;
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
                                      //_searchTextCon.clear();
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
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                              memberPhone: chat.memberPhone));
                                    },
                                    child: MessageContainer(
                                      name:
                                          chat.displayName ?? chat.memberPhone,
                                      lastMessage: chat.lastMessage,
                                      msgTime: chat.lastMsgTime,
                                      isRead: true,
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
}
