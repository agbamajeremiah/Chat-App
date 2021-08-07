import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
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
  // final nameController = TextEditingController();
  bool nameError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateProvfileViewModel>.reactive(
      onModelReady: (model) => model.initialise(),
        viewModelBuilder: () => UpdateProvfileViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25.0,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
              brightness: Brightness.dark,
              elevation: 0.0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome!!",
                            style: textStyle.copyWith(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.w900),
                          ),
                          Container(
                            width: 300,
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
                      height: checkKeyboardOpen(context)
                          ? checkPhonePortrait(context)
                              ? MediaQuery.of(context).size.height * 0.085
                              : MediaQuery.of(context).size.height * 0.05
                          : checkPhonePortrait(context)
                              ? MediaQuery.of(context).size.height * 0.25
                              : MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      child: TextFormField(
                        initialValue: model.oldProfileName ?? '',
                        // controller: nameController,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        onChanged: (value){
                          model.newProfileName = value;

                        },
                        decoration: InputDecoration(
                          hintText: model.oldProfileName ?? "Enter name",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            
                            borderSide: BorderSide(
                                color:
                                    nameError ? Colors.red : AppColors.bgGrey,
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
                      height: checkKeyboardOpen(context)
                          ? checkPhonePortrait(context)
                              ? MediaQuery.of(context).size.height * 0.15
                              : MediaQuery.of(context).size.height * 0.05
                          : checkPhonePortrait(context)
                              ? MediaQuery.of(context).size.height * 0.35
                              : MediaQuery.of(context).size.height * 0.15,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 250,
                          ),
                          padding: EdgeInsets.only(right: 10.0, bottom: 25.0),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: BusyButton(
                              title: "Continue",
                              busy: model.isBusy,
                              onPressed: () async {
                                if (model.newProfileName != null || model.oldProfileName != null) {
                                  await model.updateProfile(
                                      name: model.newProfileName ?? model.oldProfileName);
                                } else {}
                                print(model.newProfileName);
                              },
                              color: AppColors.primaryColor),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
