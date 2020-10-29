import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
        return MaterialApp(
          title: 'MSG',
          debugShowCheckedModeBanner: false,
          navigatorKey: locator<NavigationService>().navigationKey,
          theme: notifier.darkTheme == true ? darkTheme : lightTheme,
          initialRoute: SplashViewRoute,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}
