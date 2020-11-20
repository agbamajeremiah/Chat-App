import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:MSG/ui/widgets/input_field.dart';
import 'package:MSG/viewmodels/register_viewModel.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneNumber = TextEditingController();
  String errorMessage = "";
  bool isRegistering = false;
  String prefix = "+234";

  bool _checkKeyboardOpen(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    phoneNumber.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => RegisterViewModel(),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, bottom: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hello there!",
                                  style: textStyle.copyWith(
                                    fontSize: 35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              width: 210,
                              child: Text(
                                "Register your mobile number to continue!",
                                style: textStyle.copyWith(
                                  fontSize: 14.5,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _checkKeyboardOpen(context)
                            ? MediaQuery.of(context).size.height * 0.02
                            : MediaQuery.of(context).size.height * 0.125,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15),
                        alignment: Alignment.center,
                        child: errorMessage != ""
                            ? Text(errorMessage,
                                style: textStyle.copyWith(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                            : Text(""),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.white,
                              border: Border.all(
                                  color: errorMessage == ""
                                      ? AppColors.greyColor
                                      : Colors.red,
                                  width: 1)),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                  width: 1.0,
                                  color: errorMessage == ""
                                      ? AppColors.greyColor
                                      : Colors.red,
                                ))),
                                child: CountryCodePicker(
                                  padding:
                                      EdgeInsets.only(left: 5, right: 10.0),
                                  textStyle: textStyle.copyWith(
                                      fontSize: 18,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w500),
                                  onChanged: (val) {
                                    setState(() => prefix = val.toString());
                                  },
                                  //onChanged: print,
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'NG',
                                  favorite: ['+234', 'NG'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),
                              Expanded(
                                child: InputField(
                                  smallVersion: true,
                                  controller: phoneNumber,
                                  placeholder: 'Enter Number',
                                  textInputType: TextInputType.number,
                                  formatter:
                                      FilteringTextInputFormatter.digitsOnly,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _checkKeyboardOpen(context)
                            ? MediaQuery.of(context).size.height * 0.1
                            : MediaQuery.of(context).size.height * 0.2,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          constraints: BoxConstraints(maxWidth: 500),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: BusyButton(
                              busy: isRegistering ? true : false,
                              title: "Continue",
                              onPressed: () async {
                                setState(() => isRegistering = true);
                                if (phoneNumber.text != "" && prefix != "") {
                                  setState(() => errorMessage = "");
                                  String fullNumber = prefix + phoneNumber.text;
                                  if (prefix == "+234" &&
                                      phoneNumber.text.length == 11 &&
                                      phoneNumber.text[0] == "0") {
                                    fullNumber =
                                        prefix + phoneNumber.text.substring(1);
                                  }
                                  print(fullNumber);
                                  await model
                                      .login(phoneNumber: fullNumber)
                                      .then((value) {
                                    setState(() {
                                      isRegistering = false;
                                    });
                                  });
                                  phoneNumber.clear();
                                } else {
                                  setState(() {
                                    isRegistering = false;
                                    errorMessage = "Invalid Number!";
                                  });
                                }
                              },
                              color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }
}
