import 'dart:io';

Future checkInternetConnection() async {
  bool isConnected;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("connected");
      isConnected = true;
    }
  } on SocketException catch (_) {
    print("not connected");
    isConnected = false;
  }
  return isConnected;
}
