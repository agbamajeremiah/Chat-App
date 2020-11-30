import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // TextEditingController editNameController = TextEditingController();

  void _showProfileBottomSheet(BuildContext context, var model) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 170,
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      "Enter you name here",
                      style: textStyle.copyWith(
                          color: AppColors.textColor, fontSize: 17),
                    ),
                  ),
                  verticalSpace(30),
                  Container(
                    child: TextFormField(
                        autofocus: true,
                        style: textStyle.copyWith(
                            color: AppColors.textColor, fontSize: 17),
                        initialValue: model.accountName,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 5, bottom: 2),
                        ),
                        onChanged: (value) {
                          // print(value);
                          model.newAccountName = value;

                          print(model.newAccountName);
                        }
                        // autofocus: true,,
                        ),
                  ),
                  verticalSpace(20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: FlatButton(
                            // materialTapTargetSize:
                            // MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: textStyle.copyWith(
                                  color: AppColors.primaryColor, fontSize: 15),
                            )),
                      ),
                      horizontalSpaceSmall,
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: FlatButton(
                            onPressed: () async {
                              if (model.newAccountName == "") {
                                Navigator.of(context).pop();
                              } else {
                                await model
                                    .updateProfileName(
                                        name: model.newAccountName)
                                    .then((value) {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: Text(
                              "Save".toUpperCase(),
                              style: textStyle.copyWith(
                                  color: AppColors.primaryColor, fontSize: 15),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, snapshot) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: AppColors.primaryColor,
              title: Text(
                "Profile",
                style: themeData.textTheme.headline6
                    .copyWith(fontSize: 22.5, color: Colors.white),
              ),
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 25),
                          decoration:
                              BoxDecoration(color: AppColors.primaryColor),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              // color: Colors.green,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    child: Icon(
                                      Icons.person,
                                      size: 100,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 5,
                                      right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.lightBlue,
                                        radius: 17.5,
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.camera_alt,
                                              size: 17,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),
                  Container(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     spreadRadius: 1,
                            //     blurRadius: 1,
                            //     offset:
                            //         Offset(0, 0), // changes position of shadow
                            //   ),
                            // ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Icon(
                                      Icons.person,
                                      color: themeData.iconTheme.color,
                                      size: 17.5,
                                    ),
                                  ),
                                  Text(
                                    model.accountName,
                                    style: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: themeData.iconTheme.color,
                                    size: 17.5,
                                  ),
                                  onPressed: () {
                                    _showProfileBottomSheet(context, model);
                                  })
                            ],
                          ),
                        ),
                        verticalSpace(40),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     spreadRadius: 1,
                            //     blurRadius: 1,
                            //     offset:
                            //         Offset(0, 0), // changes position of shadow
                            //   ),
                            // ],
                          ),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: Icon(
                                Icons.phone,
                                color: themeData.iconTheme.color,
                                size: 17.5,
                              ),
                            ),
                            Text(
                              model.userNumber,
                              style: textStyle.copyWith(
                                fontSize: 20,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ));
        });
  }
}
