// import 'package:news_api/ui/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:MSG/ui/widgets/navbar_widget.dart';

import 'app_colors.dart';

class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      // BlogList(),
      // FavouriteView(),
      // ProfileView(),
      // SettingView()
      Container(),
      Container(),
      Container(),
      Container(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: FABBottomAppBar(
        //centerItemText: 'A',
        color: AppColors.textColor,
        selectedColor: AppColors.primaryColor,
        //Color(0xff800000),
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _onItemTapped,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.favorite, text: 'Likes'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
          FABBottomAppBarItem(iconData: Icons.lock, text: 'Setting'),
        ],
      ),

      // floatingActionButton: Container(
      //   margin: EdgeInsets.all(5),
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //     child: Icon(Icons.search),
      //     backgroundColor: Colors.black87,
      //   ),
      // ),

      // //floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
