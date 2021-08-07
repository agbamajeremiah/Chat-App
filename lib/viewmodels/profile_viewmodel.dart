import 'dart:io';
import 'dart:math';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/ui/shared/custom_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  String newAccountName = "";
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  // String get profileName;
  String get userNumber => _authenticationSerivice.userNumber;
  String get accountName => _authenticationSerivice.profileName;
  String get profileImagePath => _authenticationSerivice.profileImagePath;
  final ran = Random();

  Future updateProfileName({
    @required String name,
  }) async {
    setBusy(true);
    try {
      await _authenticationSerivice
          .updateProfile(name: name)
          .whenComplete(() => _authenticationSerivice.setNewName());
      return true;
    } catch (e) {
      debugPrint(e.message);
    }
    setBusy(false);
  }

  Future updateProfilePicture(File pictureFile) async {
    if(pictureFile == null){
      return;
    }
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final pictureDir = '/storage/emulated/0/MSG/images/profile/uploads/';
        await Directory(pictureDir).create(recursive: true);
        final picturePath = pictureDir +
            'user_image_' +
            ran.nextInt(1000000).toString() +
            '.jpg';
        debugPrint(pictureFile.path);
        final uploadFile = await compressPictureFile(
            file: pictureFile, targetPath: picturePath);
        debugPrint('yeah');
        final response = await _authenticationSerivice.sendPictureToServer(
            picture: uploadFile);
        if (response == true) {
          debugPrint("Image uploaded successfully");
          CustomToast.showSucessToast("Picture updated successfully");
          notifyListeners();
        } else {
          CustomToast.showErrorToast("Error updating image");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      CustomToast.showErrorToast("Error updating image");
    }
  }

  Future<File> compressPictureFile(
      {@required File file, @required String targetPath}) async {
    try {
      int fileSize = file.lengthSync() ~/ 1024;
      File result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: fileSize > 1000 ? 50 : 95,
      );
      debugPrint("${file.lengthSync()} bytes");
      debugPrint("${result.lengthSync()} bytes");
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
