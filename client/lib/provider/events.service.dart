import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/event.module.dart';

class EventService {
  static Future<bool> fetchEvent() async {
    final response = await http.get(
      Uri.parse('http://$apiUrl/soul_connection_api/event'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['data'];
      allEvents = body.map((json) => EventModel.fromJson(json)).toList();
      return true;
    } else {
      return false;
    }
  }
}
