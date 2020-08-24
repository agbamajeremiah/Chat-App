import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender, text;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 2,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    color: isMe ? Colors.white : AppColors.textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
