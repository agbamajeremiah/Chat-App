//import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:MSG/viewmodels/otp_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:stacked/stacked.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';

class OtpView extends StatefulWidget {
  final String phoneNumber;
  const OtpView({@required this.phoneNumber, key}) : super(key: key);
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  String text = '';
  bool otpFailed = false;
  bool verifying = false;

  @override
  void initState() {
    super.initState();
  }

  Widget otpNumberWidget(int position) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: AppColors.greyColor,
          border: otpFailed ? Border.all(color: Colors.red, width: 1.5) : null,
          shape: BoxShape.circle),
      child: Center(
          child: Text(
        text.length <= position ? "" : text[position],
        style: textStyle.copyWith(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    double _screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<OTPViewModel>.reactive(
        viewModelBuilder: () => OTPViewModel(),
        builder: (context, model, child) {
          void _onKeyboardTap(String value) async {
            if (text.length < 4) {
              setState(() {
                text = text + value;
              });
            }
            print(text.length);
            if (text.length == 4) {
              setState(() {
                otpFailed = false;
                verifying = true;
              });
              await model.verify(code: text).then((value) {
                if (value != null) {
                  setState(() {
                    otpFailed = true;
                  });
                }
                setState(() {
                  verifying = false;
                });
              });
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: AppColors.textColor,
              ),
              title: Container(
                margin: EdgeInsets.only(right: 10.0),
                child: Text(
                  "Verification",
                  style: textStyle.copyWith(
                    fontSize: 21,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: _screenHeight * 0.05,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: _screenHeight * 0.35,
                          constraints: BoxConstraints(minHeight: 210),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    'We sent you a code to verify your mobile number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Container(
                                child: otpFailed
                                    ? Text("OTP Invalid!",
                                        style: textStyle.copyWith(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))
                                    : Text(""),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    otpNumberWidget(0),
                                    otpNumberWidget(1),
                                    otpNumberWidget(2),
                                    otpNumberWidget(3),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                      child: Text("I didn't receive a code!",
                                          style: textStyle.copyWith(
                                              color: AppColors.textColor2,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      height: 15,
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return FlatButton(
                                            onPressed: () {
                                              model
                                                  .resendOTP(
                                                      phoneNumber:
                                                          widget.phoneNumber)
                                                  .then((value) {
                                                // print("otp resent");
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: new Duration(
                                                        milliseconds: 350),
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    content: Text(
                                                      'OTP Sent',
                                                      style: textStyle.copyWith(
                                                          fontSize: 13.5,
                                                          color: AppColors
                                                              .greyColor),
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              "Resend code",
                                              style: textStyle.copyWith(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // onPressed: () async {
                                            //
                                            // },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: BusyButton(
                            onPressed: () async {
                              print(text.length);
                              if (text.length == 4) {
                                setState(() {
                                  otpFailed = false;
                                  verifying = true;
                                });
                                await model.verify(code: text).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      otpFailed = true;
                                    });
                                  }
                                  setState(() {
                                    verifying = false;
                                  });
                                });
                              } else {
                                //Otp text not 4 digits
                                setState(() {
                                  otpFailed = true;
                                });
                              }
                            },
                            busy: verifying ? true : false,
                            color: Colors.blue,
                            title: "Verify Now",
                          ),
                        ),
                        //verticalSpace(10),
                        NumericKeyboard(
                          onKeyboardTap: _onKeyboardTap,
                          textColor: Colors.blue,
                          rightIcon: Icon(
                            Icons.backspace,
                            color: Colors.blue,
                          ),
                          rightButtonFn: () {
                            if (text.length > 0) {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
          );
        });
  }
}
