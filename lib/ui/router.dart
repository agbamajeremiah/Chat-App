import 'package:MSG/ui/views/chat_view.dart';
import 'package:MSG/ui/views/contacts.dart';
import 'package:MSG/ui/views/login_view.dart';
import 'package:MSG/ui/views/message_view.dart';
import 'package:MSG/ui/views/otp.dart';
import 'package:MSG/ui/views/profile_view.dart';
import 'package:MSG/ui/views/settings.dart';
import 'package:MSG/ui/views/splash_view.dart';
import 'package:MSG/ui/views/update_profile.dart';
import 'package:MSG/ui/views/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MSG/constant/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SplashView(),
      );
    case MessageViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MessagesView(),
      );
    case ChatViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatView(
          argument: settings.arguments,
        ),
      );
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case OtpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OtpView(
          phoneNumber: settings.arguments,
        ),
      );
    case ContactViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AllContacts(),
      );
    case SettingsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SettingScreen(),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    case UpdateProfileRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UpdateProfileView(),
      );
    case WelcomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WelcomeView(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

// PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => viewToShow,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, 1.0);
//       var end = Offset.zero;
//       var curve = Curves.ease;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       var offsetAnimation = animation.drive(tween);
//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//     settings: RouteSettings(
//       name: routeName,
//     ),
//   );
// }

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return CupertinoPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
