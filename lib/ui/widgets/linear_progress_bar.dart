import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class LinearProgressBar extends StatefulWidget {
  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    // controller =
    // AnimationController(duration: const Duration(seconds: 2), vsync: this);
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    // #docregion addListener
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        value: animation.value,
        backgroundColor: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
