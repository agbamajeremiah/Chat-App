import 'package:MSG/constant/assets.dart';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/custom_clip.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              color: Colors.blue,
              height: 500,
              width: screenWidth(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: welcomeText,
                  ),
                  verticalSpace(20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 311,
                        child: Image.asset(AppAssets.background),
                      ),
                      SizedBox(
                        width: 233,
                        height: 163,
                        child: Image.asset(AppAssets.chat),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: SizedBox(
              width: 200,
              child: BusyButton(
                  title: 'Continue',
                  onPressed: () =>
                      Navigator.pushNamed(context, MessageViewRoute),
                  color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
