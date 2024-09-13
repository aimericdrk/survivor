import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/encounter.module.dart';

class EncounterService {
  static Future<bool> fetchEncounter() async {
    final response = await http.get(
      Uri.parse('http://$apiUrl/soul_connection_api/encounter'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['data'];
      allEncounters = body.map((json) => EncounterModel.fromJson(json)).toList();
      return true;
    } else {
      return false;
    }
  }
}
