import 'package:soul_connection/constants/constants.dart';

class WatchOSWrapper {
  static Future<void> sendDataToAppleWatch() async {
    await channel.invokeMethod(
      "flutterToWatch",
      {
        "method": "sendDataToNative",
        "datas": {
          // "customers": allCustomers.map((e) => e.toJson()).toList(),
          // "coachs": allCoaches.map((e) => e.toJson()).toList(),
          "tips": allTips.map((e) => e.toJson()).toList()
          // "events": allEvents.map((e) => e.toJson()).toList(),
        },
      },
    );
  }
}
