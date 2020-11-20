import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:MSG/viewmodels/update_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class UpdateProfileView extends StatefulWidget {
  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final nameController = TextEditingController();
  bool nameError = false;

  bool _checkKeyboardOpen(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateProvfileViewModel>.reactive(
        viewModelBuilder: () => UpdateProvfileViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: AppColors.textColor),
                elevation: 0.0,
                backgroundColor: Colors.white,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Welcome!!",
                            style: textStyle.copyWith(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Enter your profile name to continue",
                            style: textStyle.copyWith(
                                color: AppColors.textColor2,
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: _checkKeyboardOpen(context)
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          /*borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        */
                          borderSide: BorderSide(
                              color: nameError ? Colors.red : AppColors.bgGrey,
                              width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: AppColors.bgGrey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: _checkKeyboardOpen(context)
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.height * 0.1),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 250,
                        ),
                        padding: EdgeInsets.only(right: 15.0),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: BusyButton(
                            title: "Continue",
                            busy: model.isBusy,
                            onPressed: () async {
                              if (nameController.text != "") {
                                await model.updateProfile(
                                    name: nameController.text);
                              } else {}
                              print(nameController.text);
                            },
                            color: Colors.blue),
                      )),
                  SizedBox(height: _checkKeyboardOpen(context) ? 20 : 10),
                ],
              ),
            ),
          );
        });
  }
}
