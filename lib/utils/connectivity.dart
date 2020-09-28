import 'dart:io';

import 'package:connectivity/connectivity.dart';

Future checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("connected");
      return true;
    }
  } on SocketException catch (_) {
    print("not connected");
    return false;
  }
}

Future internetConnected() async {
  var connectionResult = await Connectivity().checkConnectivity();
  if (connectionResult == ConnectivityResult.mobile ||
      connectionResult == ConnectivityResult.wifi) {
    print("connected");
    return true;
  } else {
    print(" Not connected");
    return false;
  }
}
