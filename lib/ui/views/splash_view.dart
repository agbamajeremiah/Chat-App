import 'dart:async';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.pushNamed(context, ContactViewRoute));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
        viewModelBuilder: () => StartUpViewModel(),
        onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, snapshot) {
          return Scaffold(
            backgroundColor: Colors.blueAccent,
            body: Center(
              child: Text(
                "MSG",
                style: textStyle.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          );
        });
  }
}
