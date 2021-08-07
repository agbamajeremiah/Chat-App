import 'dart:io';
import 'package:MSG/constant/assets.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File _imageFile;
  final picker = ImagePicker();

  Future<bool> _getImage(bool camara) async {
    var pickedFile;
    try {
      if (camara == true) {
        pickedFile = await picker.getImage(source: ImageSource.camera);
      } else {
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      }
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void _showProfileBottomSheet(BuildContext context, var model) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Enter you name here",
                    style: textStyle.copyWith(
                        color: AppColors.textColor, fontSize: 17.5),
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
                      child: TextButton(
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
                      child: TextButton(
                          onPressed: () async {
                            if (model.newAccountName == "") {
                              Navigator.of(context).pop();
                            } else {
                              await model
                                  .updateProfileName(name: model.newAccountName)
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
                ),
                verticalSpace(20),
              ],
            ),
          );
        });
  }

  void _showUploadPictureBottomSheet(BuildContext context, var model) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          print(model.userNumber);
          return Container(
            height: 150,
            padding: EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    await _getImage(true);
                    await model
                        .updateProfilePicture(_imageFile)
                        .then((value) {});
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          AppAssets.camera_icon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Camera',
                            style: textStyle.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                horizontalSpaceMedium,
                InkWell(
                  onTap: () async {
                    await _getImage(false);
                    await model
                        .updateProfilePicture(_imageFile)
                        .then((value) {});
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          AppAssets.gallery_icon,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Gallery',
                            style: textStyle.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ],
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
          print("image path: ${model.profileImagePath}");
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              backgroundColor: AppColors.primaryColor,
              title: Text(
                "Profile",
                style: themeData.textTheme.headline6.copyWith(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                          margin: EdgeInsets.only(bottom: 20),
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
                                      radius: 65,
                                      backgroundImage: _imageFile != null
                                          ? FileImage(_imageFile) : model.profileImagePath != null  ? FileImage(File(model.profileImagePath))
                                          : AssetImage(
                                              AppAssets.profile_default_pics)),
                                  // Change profile picture button
                                  Positioned(
                                      bottom: 5,
                                      right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.lightBlue,
                                        radius: 20,
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.camera_alt,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _showUploadPictureBottomSheet(
                                                  context, model);
                                            },
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
                            shape: BoxShape.rectangle,
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
                                    model.accountName ?? "No name",
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
          );
        });
  }
}
