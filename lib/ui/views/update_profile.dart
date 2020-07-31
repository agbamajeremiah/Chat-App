import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/ui/widgets/busy_button.dart';
import 'package:MSG/ui/widgets/input_field.dart';
import 'package:MSG/viewmodels/update_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class UpdateProfileView extends StatelessWidget {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<UpdateProvfileViewModel>.withConsumer(
        viewModelBuilder: () => UpdateProvfileViewModel(),
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
                      "Welcome, Please update your name",
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
                          Expanded(
                            child: InputField(
                              controller: nameController,
                              placeholder: 'Enter Your name',
                            ),
                          )
                        ],
                      ),
                    ),
                    verticalSpace(20),
                    BusyButton(
                        title: "Continue",
                        busy: model.busy,
                        onPressed: () async {
                          await model.updateProfile(name: nameController.text);
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
