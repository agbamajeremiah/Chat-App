import 'package:MSG/ui/views/chat/chat_view.dart';
import 'package:MSG/ui/views/contact/contacts.dart';
import 'package:MSG/ui/views/auth/login_view.dart';
import 'package:MSG/ui/views/chat/message_view.dart';
import 'package:MSG/ui/views/auth/otp.dart';
import 'package:MSG/ui/views/profile/profile_view.dart';
import 'package:MSG/ui/views/settings/settings.dart';
import 'package:MSG/ui/views/splash_view.dart';
import 'package:MSG/ui/views/auth/update_profile.dart';
import 'package:MSG/ui/views/auth/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/custom_page_route.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SplashView(),
      );
    case MessageViewRoute:
      return _noTransitionPageRoute(
        routeName: settings.name,
        viewToShow: MessagesView(
          firstTime: settings.arguments,
        ),
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

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return CupertinoPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}

PageRoute _noTransitionPageRoute({String routeName, Widget viewToShow}) {
  return CustomPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
