import 'package:data_connection_checker/data_connection_checker.dart';

class NetworkInfo {
  Future<bool> get isConnected => DataConnectionChecker().hasConnection;
}
