import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/ui/router.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

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
      // supportedLocales: [
      //   Locale('en'),
      //   Locale('it'),
      //   Locale('fr'),
      //   Locale('es'),
      //   Locale('de'),
      //   Locale('pt'),
      // ],
      // localizationsDelegates: [
      //   CountryLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashViewRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
