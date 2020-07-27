import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:MSG/ui/widgets/input_field.dart';
import 'package:MSG/viewmodels/register_viewModel.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneNumber = TextEditingController();
  String prefix = "+234";

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RegisterViewModel>.withConsumer(
        viewModelBuilder: () => RegisterViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, Enter your phone number",
                      style: textStyle.copyWith(
                        fontSize: 30,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(20),
                    Container(
                      decoration: fieldDecortaion,
                      child: Row(
                        children: [
                          Container(
                            child: CountryCodePicker(
                              textStyle: textStyle.copyWith(
                                  color: AppColors.textColor),
                              onChanged: (value) {
                                setState(() {
                                  prefix = value.toString();
                                });
                              },
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
                              controller: phoneNumber,
                              placeholder: 'Enter Number',
                              textInputType: TextInputType.phone,
                              formatter:
                                  WhitelistingTextInputFormatter.digitsOnly,
                            ),
                          )
                        ],
                      ),
                    ),
                    verticalSpace(20),
                    BusyButton(
                        title: "Continue",
                        busy: model.busy,
                        onPressed: () {
                          // print(prefix + phoneNumber.text);
                          model.login(phoneNumber: prefix + phoneNumber.text);
                        },
                        color: Colors.blue)
                  ],
                ),
              ),
            ),
          );
        });
  }
}
