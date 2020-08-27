import 'package:MSG/models/chat.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ChatView extends StatefulWidget {
  final Chat chat;
  ChatView({Key key, @required this.chat}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final messageTextController = TextEditingController();
  bool typingMessage = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChatViewModel>.withConsumer(
        viewModelBuilder: () => ChatViewModel(
            threadId: widget.chat.id, phoneNumber: widget.chat.memberPhone),
        //onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, snapshot) {
          final chatMessages = model.getChatMessages();
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: CustomAppBar(
                  title: widget.chat.displayName ?? widget.chat.memberPhone,
                  back: true,
                )),
            body: SafeArea(
              child: Column(
                children: [
                  FutureBuilder(
                      future: chatMessages,
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Center(
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    AppColors.primaryColor),
                              ),
                            ),
                          );
                        } else {
                          List<Message> allMessages = snapshot.data;
                          final messageCount = allMessages.length;
                          return messageCount > 0
                              ? Expanded(
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
                                        sender: message.sender,
                                        text: message.content.toString(),
                                        isMe:
                                            message.sender == model.userNumber,
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
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            decoration: kMessageTextFieldDecoration,
                            onTap: () {
                              setState(() => typingMessage = true);
                            },
                          ),
                        ),
                        FlatButton(
                            onPressed: () async {
                              String messageText = messageTextController.text;
                              String receiver = widget.chat.memberPhone;

                              await model.sendMessage(
                                  message: messageText,
                                  receiver: receiver,
                                  isQuote: false);
                              messageTextController.clear();
                              setState(() => typingMessage = false);
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
