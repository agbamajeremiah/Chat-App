import 'dart:io';
import 'dart:math';
import 'package:MSG/services/database_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadService {
  Future<String> downloadContactPicture(
      {@required String pictureUrl,
      @required String contactName,
      @required contactNumber}) async {
    Dio dio = Dio();
    final Random ran = Random();
    try {
      final PermissionStatus permissionStatus = await _getStoragePermission();
      if (permissionStatus == PermissionStatus.granted) {
        final fileName = contactName != null
            ? contactName.split(' ')[0].toLowerCase() +
                '_' +
                ran.nextInt(10000000).toString() +
                '.jpg'
            : 'profile_' + ran.nextInt(1000000).toString() + '.jpg';
        final pictureDir = '/storage/emulated/0/MSG/images/profile_pics/';
        await Directory(pictureDir).create(recursive: true);
        final picturePath = pictureDir + fileName;
        final downloadRes = await dio.download(pictureUrl, picturePath);
        if (downloadRes.statusCode == 200) {
          Map<String, dynamic> updateData = {
            DatabaseService.COLUMN_PROFILE_PICTURE_URL: pictureUrl,
            DatabaseService.COLUMN_PROFILE_DOWNLOAD_PATH: picturePath,
            DatabaseService.COLUMN_PROFILE_PICTURE_DOWNLOADED: 1,
          };
          await DatabaseService.db.updateRegContact(updateData, contactNumber);
          return picturePath;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e);
      return null;
    }
  }

  Future<String> downloadUserPicture({
    @required String pictureUrl,
  }) async {
    Dio dio = Dio();
    final Random ran = Random();
    try {
      final PermissionStatus permissionStatus = await _getStoragePermission();
      if (permissionStatus == PermissionStatus.granted) {
        final pictureDir = '/storage/emulated/0/MSG/images/profile/uploads/';
        await Directory(pictureDir).create(recursive: true);
        final picturePath = pictureDir +
            'user_image_' +
            ran.nextInt(1000000).toString() +
            '.jpg';
        final downloadRes = await dio.download(pictureUrl, picturePath,
            onReceiveProgress: (progress, total) {
          debugPrint("$progress of $total");
        });
        if (downloadRes?.statusCode == 200) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("profileImagePath", picturePath);
          return picturePath;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e);
    }
    return null;
  }

  //Check storage permission
  Future<PermissionStatus> _getStoragePermission() async {
    var permission = await Permission.storage.status;
    if (!permission.isGranted || permission.isDenied) {
      permission = await Permission.storage.request();
      return permission;
    } else {
      return permission;
    }
  }
}
