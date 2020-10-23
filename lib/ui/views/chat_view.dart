import 'package:MSG/models/chat.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
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
  final messageTextController = TextEditingController();
  bool typingMessage = false;
  bool rebuild;

  @override
  Widget build(BuildContext context) {
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
          print(model.busy.toString());
          final chatMessages = model.getChatMessages();
          model.synChat();
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 2.0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.textColor,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                title: Text(
                  chat.displayName ?? chat.memberPhone,
                  style: textStyle.copyWith(
                      fontSize: 20.5, color: AppColors.textColor),
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
                        future: chatMessages,
                        builder: (context, snapshot) {
                          // print(snapshot.data);
                          if (!snapshot.hasData) {
                            return Expanded(
                              child: Container(),
                            );
                          } else {
                            List<Message> allMessages = snapshot.data;
                            final messageCount = allMessages.length;
                            return messageCount > 0
                                ? Expanded(
                                    child: ListView.builder(
                                      reverse: true,
                                      itemCount: messageCount,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 20),
                                      itemBuilder: (context, index) {
                                        final message = allMessages[index];
                                        return MessageBubble(
                                          sender: message.sender,
                                          text: message.content.toString(),
                                          isMe: message.sender ==
                                              model.userNumber,
                                          messageTime: message.createdAt,
                                          status: message.status,
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
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
                        }),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              maxLines: 3,
                              minLines: 1,
                              controller: messageTextController,
                              decoration: kMessageTextFieldDecoration,
                              onTap: () {
                                setState(() => typingMessage = true);
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            padding: EdgeInsets.only(right: 5),
                            child: FlatButton(
                                onPressed: () async {
                                  String messageText =
                                      messageTextController.text;
                                  String receiver = chat.memberPhone;
                                  if (messageText.length > 0) {
                                    await model.sendMessage(
                                        message: messageText,
                                        receiver: receiver,
                                        isQuote: false);
                                  }
                                  messageTextController.clear();
                                  setState(() => typingMessage = false);
                                },
                                child: Icon(
                                  Icons.send,
                                  size: 20,
                                )),
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
