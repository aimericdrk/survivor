import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/tips.module.dart';

class TipsService {
  static Future<bool> fetchTips() async {
    final response = await http.get(
      Uri.parse('http://$apiUrl/soul_connection_api/tip'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['data'];
      allTips = body.map((json) => TipsModel.fromJson(json)).toList();
      return true;
    } else {
      return false;
    }
  }
}
