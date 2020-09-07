import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/ui/router.dart';
import 'package:flutter/material.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context)
            .appBarTheme
            .copyWith(color: Colors.white, brightness: Brightness.dark),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
        //ThemeData(
        //   appBarTheme: AppBarTheme(
        //     brightness: Brightness.dark,
        //     color: Colors.white,
        //   ),
        //   primaryColor: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashViewRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
