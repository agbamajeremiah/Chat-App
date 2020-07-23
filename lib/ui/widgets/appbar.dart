import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final bool back;
  CustomAppBar({@required this.title, this.back = false});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: widget.back
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        "${widget.title}",
        style: textStyle.copyWith(fontSize: 20, color: AppColors.textColor),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: AppColors.textColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
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
    );
  }
}
