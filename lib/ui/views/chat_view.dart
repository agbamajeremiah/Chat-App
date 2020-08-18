import 'package:MSG/models/chat.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ChatView extends StatelessWidget {
  final Chat chat;
  ChatView({Key key, @required this.chat}) : super(key: key);
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //test
    /*
    String timeFromServer = "2020-08-07T12:16:05.8772Z";
    DateTime dte = DateTime.parse(timeFromServer);
    print(dte);
    print(DateFormat.E().format(DateTime.parse(timeFromServer)));
    */
    return ViewModelProvider<ChatViewModel>.withConsumer(
        viewModelBuilder: () =>
            ChatViewModel(threadId: chat.id, phoneNumber: chat.memberPhone),
        builder: (context, model, snapshot) {
          final chatMessages = model.getChatMessages();
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: CustomAppBar(
                  title: chat.displayName ?? chat.memberPhone,
                  back: true,
                )),
            body: SafeArea(
              child: Column(
                children: [
                  FutureBuilder(
                      future: chatMessages,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "No Conversation yet",
                                    style: textStyle.copyWith(
                                        color: AppColors.textColor,
                                        fontSize: 15.0),
                                  ),
                                )),
                          );
                        } else {
                          List<Message> allMessages = snapshot.data;
                          final messageCount = allMessages.length;
                          return Expanded(
                              child: ListView.builder(
                            itemCount: messageCount,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            itemBuilder: (context, index) {
                              final message = allMessages[index];
                              print(message.content);
                              print(message.createdAt);
                              print(message.sender);

                              return MessageBubble(
                                sender: "ssjsjj",
                                text: message.content.toString(),
                                isMe: true,
                              );
                            },
                          ));
                        }
                      }),
                  Container(
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                        FlatButton(
                            onPressed: () async {
                              String messageText = messageTextController.text;
                              String receiver = chat.memberPhone;
                              dynamic response = await model.sendMessage(
                                  message: messageText,
                                  receiver: receiver,
                                  isQuote: false);
                              messageTextController.clear();
                            },
                            child: Icon(
                              Icons.send,
                              size: 20,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
