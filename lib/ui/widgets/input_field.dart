import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String validationMessage;
  final Function enterPressed;
  final bool smallVersion;
  final FocusNode fieldFocusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final String additionalNote;
  final Function(String) onChanged;
  final TextInputFormatter formatter;
  final IconData icon;

  InputField({
    @required this.controller,
    @required this.placeholder,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.formatter,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.isReadOnly = false,
    this.smallVersion = false,
    this.icon,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPassword;
  double fieldHeight = 55;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.smallVersion ? 40 : fieldHeight,
          alignment: Alignment.centerLeft,
          padding: fieldPadding,
          decoration:
              widget.isReadOnly ? disabledFieldDecortaion : fieldDecortaion,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: widget.password
                    ? () => setState(() {
                          isPassword = !isPassword;
                        })
                    : null,
                child: widget.password
                    ? Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        child: Icon(
                          isPassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textColor,
                        ),
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        child: widget != null
                            ? Icon(
                                widget.icon,
                                color: AppColors.textColor,
                              )
                            : null,
                      ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: AppColors.textColor,
                    ),
                  ),
                  inputFormatters:
                      widget.formatter != null ? [widget.formatter] : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode.requestFocus();
                    }
                  },
                  obscureText: isPassword,
                  readOnly: widget.isReadOnly,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: widget.placeholder,
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote),
        verticalSpaceSmall
      ],
    );
  }
}
