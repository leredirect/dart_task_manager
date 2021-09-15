import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  static Future<bool> isOnline() async {
    var onlineStatus = await (Connectivity().checkConnectivity());
   return onlineStatus != ConnectivityResult.none;
  }
}
