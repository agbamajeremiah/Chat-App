import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Elisha",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  MessageBubble(
                    sender: "ssjsjj",
                    text: "ssjsjjsjs",
                    isMe: true,
                  ),
                  MessageBubble(
                    sender: "ssjsjj",
                    text: "ssjsjjsjs",
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
                      onPressed: () {
                        //Implement send functionality.
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
  }
}
