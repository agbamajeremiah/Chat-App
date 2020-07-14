import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';

import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  double elevation = 0;
  String name = "jdjdj";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: elevation,
        title: Text(
          "Messages",
          style: textStyle.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
            color: AppColors.textColor,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {});
              },
              child: Center(
                  child: Icon(
                Icons.more_vert,
                size: 25,
                color: AppColors.textColor,
              )),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Value1',
                  child: Text('Choose value 1'),
                ),
                PopupMenuItem<String>(
                  value: 'Value2',
                  child: Text('Choose value 2'),
                ),
                PopupMenuItem<String>(
                  value: 'Value3',
                  child: Text('Choose value 3'),
                ),
              ],
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: messages,
            )),
      ),
    );
  }
}

const messages = [
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
];
