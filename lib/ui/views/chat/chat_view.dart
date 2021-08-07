import 'dart:io';
import 'package:MSG/constant/assets.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/ui/widgets/chatPopupMenu.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:MSG/viewmodels/chat_viewmodel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool typingMessage = false;
  bool loadMessages = false;
  void _scrollListener() {
    var _maxExtent =
        (_chatListController.position.maxScrollExtent / 10).round();
    var _addition = (_maxExtent / 2.5).round();
    var _scrollPixels =
        (_chatListController.position.pixels / 10).round() + _addition;
    // print("Pixel: $_scrollPixels");
    // print("ScrollExtent: $_maxExtent");

    if (_scrollPixels == _maxExtent) {
      setState(() => loadMessages = true);
    }
    //  if (_chatListController.position.pixels == _chatListController.position.maxScrollExtent) {
    //   setState(() => loadMessages = true);
    //   print("Load more messages");
    // }
  }

  @override
  void initState() {
    super.initState();
    _chatListController.addListener(_scrollListener);
    AwesomeNotifications().dismissAllNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    _chatListController.removeListener(_scrollListener);
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
              displayName: chat.displayName,
              favourite: chat.favourite == 1
                  ? true
                  : chat.favourite == 0
                      ? false
                      : null,
              contactChatID: chat.contactChatID,
              pictureUrl: chat.pictureUrl,
              picturePath: chat.picturePath,
              profilePictureDownloaded: chat.profilePictureDownloaded,
              fromContact: fromContact,
            ),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, snapshot) {
          if (loadMessages == true) {
            model.fetchMoreChatMessages().then((value) {
              // print(value);
            });
          }
          model.updateReadMessageWithoutRebuild();
          List<ChatMessage> allMessages = model.chatMessages;
          List messageWithTime = [];

          final int messageCount = allMessages.length;
          if (messageCount > 0) {
            for (int i = 0; i < messageCount; i++) {
              if (i != 0 &&
                  (DateTime.parse(allMessages[i - 1].createdAt).day -
                          DateTime.parse(allMessages[i].createdAt).day) >
                      0) {
                messageWithTime
                    .add(getDisplayDate(allMessages[i - 1].createdAt));
              }
              messageWithTime.add(allMessages[i]);
            }
            messageWithTime.add(getDisplayDate(allMessages.last.createdAt));
          }
          return Consumer<ThemeNotifier>(
            builder: (context, notifier, child) {
              return Scaffold(
                backgroundColor: AppColors.bgGrey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(65.0),
                  child: AppBar(
                    brightness: Brightness.light,
                    backgroundColor: AppColors.bgGrey,
                    elevation: 0.0,
                    centerTitle: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 25.0,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                            radius: 20,
                            backgroundImage: model.profilePictureDownloaded == 1
                                ? FileImage(File(model.picturePath))
                                : AssetImage(AppAssets.profile_default_pics),
                            backgroundColor: notifier.darkTheme == true
                                ? Colors.grey
                                : Colors.grey[400]),
                        horizontalSpaceSmall,
                        model.displayName == null || model.displayName.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    model.phoneNumber,
                                    style:
                                        themeData.textTheme.headline6.copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    model.displayName,
                                    style:
                                        themeData.textTheme.headline6.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    model.phoneNumber ?? "",
                                    style:
                                        themeData.textTheme.headline6.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                        horizontalSpaceMedium,
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: ChatPopupMenu(
                            model.favourite, model.toggleChatFavavourite),
                      )
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    FutureBuilder(
                        future: model.fetchLoadChatMessages(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Expanded(
                              child: Container(),
                            );
                          } else {
                            return Expanded(
                              child: (snapshot.data == true)
                                  ? ListView.builder(
                                      controller: _chatListController,
                                      reverse: true,
                                      itemCount: messageWithTime.length,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 25),
                                      itemBuilder: (context, index) {
                                        final item = messageWithTime[index];
                                        return (item is String)
                                            ? Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 5.0),
                                                  child: Text(
                                                    item,
                                                    style: themeData
                                                        .textTheme.bodyText1,
                                                  ),
                                                ),
                                              )
                                            : MessageBubble(
                                                sender: item.sender,
                                                text: item.content.toString(),
                                                isMe: item.sender ==
                                                    model.accountNumber,
                                                messageTime: item.createdAt,
                                                status: item.status,
                                              );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(top: 25.0),
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
                        }),
                    Material(
                      elevation: 8.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 55,
                              padding: EdgeInsets.only(left: 5),
                              child: TextButton(
                                  onPressed: () async {},
                                  child: Icon(Icons.tag_faces_outlined,
                                      size: 35, color: Colors.black)),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 4,
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
                              width: 100,
                              padding: EdgeInsets.only(right: 5),
                              child: InkWell(
                                  onTap: () async {
                                    String messageText =
                                        _messageTextController.text.trim();
                                    String receiver = chat.memberPhone;
                                    if (messageText.length > 0) {
                                      model.saveNewMessage(
                                          message: messageText,
                                          receiver: receiver,
                                          isQuote: false);
                                      _messageTextController.clear();
                                    }
                                    setState(() => typingMessage = false);
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Center(
                                      child: Icon(
                                          Icons
                                              .subdirectory_arrow_right_rounded,
                                          size: 22.5,
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
