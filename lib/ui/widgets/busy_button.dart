import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
//import 'package:MSG/ui/shared/app_colors.dart';

/// A button that shows a busy indicator in place of title
class BusyButton extends StatefulWidget {
  final bool busy;
  final String title;
  final Function onPressed;
  final bool enabled, outline;
  final Color color;
  const BusyButton({
    @required this.title,
    this.busy = false,
    @required this.onPressed,
    this.enabled = true,
    this.outline = false,
    @required this.color,
  });

  @override
  _BusyButtonState createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.busy ? widget.onPressed : null,
      child: InkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: !widget.busy
              ? Text(widget.title,
                  style: buttonTitleTextStyleBlack.copyWith(
                      color: Colors.white, fontSize: 17))
              : SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
        ),
      ),
    );
  }
}
