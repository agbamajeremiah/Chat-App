import 'package:MSG/models/chat.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:MSG/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StatefulWidget {
  final Map argument;
  ChatView({Key key, @required this.argument}) : super(key: key);
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ScrollController _chatListController = ScrollController();
  final TextEditingController _messageTextController = TextEditingController();
  bool rebuild;
  bool typingMessage = false;
  int _chatListCount = 1;
  void _scrollListener() {
    if (_chatListController.position.maxScrollExtent ==
        _chatListController.position.pixels) {
      setState(() => _chatListCount++);
      print(_chatListCount);
    }
  }

  @override
  void initState() {
    _chatListController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _chatListController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Chat chat = widget.argument['chat'];
    bool fromContact = widget.argument['fromContact'];
    return ViewModelBuilder<ChatViewModel>.reactive(
        viewModelBuilder: () => ChatViewModel(
            threadId: chat.id,
            phoneNumber: chat.memberPhone,
            fromContact: fromContact),
        onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, snapshot) {
          final getChatMessages = model.getChatMessages();
          model.synChat();
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                title: Text(
                  chat.displayName ?? chat.memberPhone,
                  style: themeData.textTheme.headline6.copyWith(
                    fontSize: 22.5,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MyPopupMenu(),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getChatMessages,
                        builder: (context, snapshot) {
                          // print(snapshot.data);
                          if (!snapshot.hasData) {
                            return Expanded(
                              child: Container(),
                            );
                          } else {
                            List<Message> allMessages = model.chatMessages;
                            final int messageCount = allMessages.length;
                            if (messageCount > 0) {
                              List messageWithTime = [];
                              for (int i = 0; i < messageCount; i++) {
                                if (i != 0 &&
                                    (DateTime.parse(allMessages[i - 1]
                                                    .createdAt)
                                                .day -
                                            DateTime.parse(
                                                    allMessages[i].createdAt)
                                                .day) >
                                        0) {
                                  messageWithTime.add(getDisplayDate(
                                      allMessages[i - 1].createdAt));
                                }
                                messageWithTime.add(allMessages[i]);
                              }
                              messageWithTime.add(
                                  getDisplayDate(allMessages.last.createdAt));

                              return Expanded(
                                child: ListView.builder(
                                  controller: _chatListController,
                                  reverse: true,
                                  itemCount: messageWithTime.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 20),
                                  itemBuilder: (context, index) {
                                    final item = messageWithTime[index];
                                    return (item is String)
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                item,
                                                style: themeData
                                                    .textTheme.bodyText1,
                                              ),
                                              //   decoration: BoxDecoration(
                                              //       color: Colors.grey,
                                              //       borderRadius:
                                              //           BorderRadius.circular(5)),
                                            ),
                                          )
                                        : MessageBubble(
                                            sender: item.sender,
                                            text: item.content.toString(),
                                            isMe:
                                                item.sender == model.userNumber,
                                            messageTime: item.createdAt,
                                            status: item.status,
                                          );
                                  },
                                ),
                              );
                            } else {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "No Messages",
                                      style: textStyle.copyWith(
                                          color: AppColors.textColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: themeData.primaryColor, width: 1.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              maxLines: 3,
                              minLines: 1,
                              controller: _messageTextController,
                              style: themeData.textTheme.bodyText1.copyWith(
                                fontSize: 18.0,
                              ),
                              onTap: () {
                                setState(() => typingMessage = true);
                              },
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            padding: EdgeInsets.only(right: 5),
                            child: FlatButton(
                                onPressed: () async {
                                  String messageText =
                                      _messageTextController.text;
                                  String receiver = chat.memberPhone;
                                  if (messageText.length > 0) {
                                    await model.saveNewMessage(
                                        message: messageText,
                                        receiver: receiver,
                                        isQuote: false);
                                    _messageTextController.clear();
                                  }
                                  setState(() => typingMessage = false);
                                },
                                child: Icon(Icons.send,
                                    size: 20,
                                    color: themeData.iconTheme.color)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
