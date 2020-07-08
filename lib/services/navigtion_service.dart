import 'package:flutter/material.dart';

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
        //.pushNamed(routeName, arguments: arguments);
        //.pushAndRemoveUntil();
        .pushNamedAndRemoveUntil(routeName, (r) => false, arguments: arguments);
  }
}
