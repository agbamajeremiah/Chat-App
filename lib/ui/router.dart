import 'package:MSG/ui/views/chat_view.dart';
import 'package:MSG/ui/views/contacts.dart';
import 'package:MSG/ui/views/login_view.dart';
import 'package:MSG/ui/views/message_view.dart';
import 'package:MSG/ui/views/otp.dart';
import 'package:MSG/ui/views/settings.dart';
import 'package:MSG/ui/views/splash_view.dart';
import 'package:MSG/ui/views/update_profile.dart';
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
          phoneNumber: settings.arguments,
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
        viewToShow: OtpView(),
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
    case UpdateProfileRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UpdateProfileView(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
