import 'package:flutter/material.dart';
import 'package:MSG/constant/route_names.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> clearLastAndNavigateTo(String routeName,
      {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> removeAllAndNavigateTo(String routeName,
      {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, (r) => false, arguments: arguments);
  }

//For Notification on click
  Future<dynamic> clearAllExceptHomeAndNavigateTo(String routeName,
      {dynamic arguments}) {
    return _navigationKey.currentState.pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(MessageViewRoute),
        arguments: arguments);
  }
}
