import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
//import 'package:MSG/ui/widgets/appbar.dart';
import 'package:MSG/ui/widgets/message_widget.dart';
import 'package:MSG/ui/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagesView extends StatefulWidget {
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController _searchTextCon = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    _searchTextCon.addListener(() {
      setState(() {
        _searchQuery = _searchTextCon.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchTextCon.dispose();
    super.dispose();
  }

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
      appBar: (_isSearching)
          ? AppBar(
              iconTheme: IconThemeData(
                color: AppColors.textColor,
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchQuery = "";
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    // override textfield's icon color when selected
                    primaryColor: AppColors.textColor,
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: _searchTextCon,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Search...",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchTextCon.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          : AppBar(
              iconTheme: IconThemeData(
                color: AppColors.textColor,
              ),
              elevation: 2,
              backgroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Select Contact",
                    style: textStyle.copyWith(
                        color: AppColors.textColor, fontSize: 20),
                  ),
                ],
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
                MyPopupMenu(),
              ],
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
