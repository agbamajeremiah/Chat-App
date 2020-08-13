import 'package:MSG/models/contacts.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:MSG/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ChatView extends StatelessWidget {
  final String phoneNumber;
  ChatView({Key key, @required this.phoneNumber}) : super(key: key);
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(phoneNumber);
    return ViewModelProvider<ChatViewModel>.withConsumer(
        viewModelBuilder: () => ChatViewModel(),
        builder: (context, model, snapshot) {
          final contactResponse = model.getContactInfo(phoneNumber);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: FutureBuilder(
                  future: contactResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      MyContact contact = snapshot.data;
                      return CustomAppBar(
                        title: contact.fullName,
                        back: true,
                      );
                    } else {
                      return Container(color: Colors.white);
                    }
                  }),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: [
                        MessageBubble(
                          sender: "ssjsjj",
                          text: "ssjsjjsjs",
                          isMe: true,
                        ),
                        MessageBubble(
                          sender: "ssjsjj",
                          text:
                              "ssjsjjsjs djdj d  djdjd djd ddnj djdj d dj ddjd djd cjd cjd ",
                          isMe: false,
                        ),
                      ],
                    ),
                  ),
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
                              String receiver = phoneNumber;
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
