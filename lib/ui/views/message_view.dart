import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/widgets/appbar.dart';

import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    super.initState();
  }

  double elevation = 0;
  String name = "jdjdj";
  @override
  Widget build(BuildContext context) {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Messages",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ChatViewRoute);
                },
                child: MessageContainer(
                  name: "Elisha",
                  message: "You Know I love you ba",
                  isRead: true,
                ),
              ),
              Divider(),
              MessageContainer(
                name: "Prince",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
              ),
              Divider(),
              MessageContainer(
                name: "Tg",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
                isRead: true,
              ),
              Divider(),
              MessageContainer(
                name: "Cy",
                message: "You Know I love you ba",
              ),
              Divider(),
              MessageContainer(
                name: "Elisha",
                message: "You Know I love you ba",
                isRead: true,
              ),
              Divider(),
              MessageContainer(
                name: "Prince",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
              ),
              Divider(),
              MessageContainer(
                name: "Tg",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
                isRead: true,
              ),
              Divider(),
              MessageContainer(
                name: "Cy",
                message: "You Know I love you ba",
              ),
              Divider(),
              MessageContainer(
                name: "Elisha",
                message: "You Know I love you ba",
                isRead: true,
              ),
              Divider(),
              MessageContainer(
                name: "Prince",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
              ),
              MessageContainer(
                name: "Tg",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
                isRead: true,
              ),
              MessageContainer(
                name: "Cy",
                message: "You Know I love you ba",
              ),
              MessageContainer(
                name: "Elisha",
                message: "You Know I love you ba",
                isRead: true,
              ),
              MessageContainer(
                name: "Prince",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
              ),
              MessageContainer(
                name: "Tg",
                message:
                    "You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba You Know I love you ba",
                isRead: true,
              ),
              MessageContainer(
                name: "Cy",
                message: "You Know I love you ba",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
