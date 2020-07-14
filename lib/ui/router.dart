import 'package:MSG/ui/views/chat_view.dart';
import 'package:MSG/ui/views/message_view.dart';
import 'package:MSG/ui/views/splash_view.dart';
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
        viewToShow: ChatView(),
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
