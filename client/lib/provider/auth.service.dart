import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';

class AuthService {
  static Future<Map<String, dynamic>> signUp(
    String email,
    String password,
    String username,
    String gender,
    String birthday,
    String surname,
    String work,
  ) async {
    final url = Uri.parse('http://$apiUrl/register_employee');

    final Map<String, String> body = {
      'name': username,
      'email': email,
      'password': password,
      'surname': surname,
      'birth_date': birthday,
      'gender': gender,
      'work': work,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Group-Authorization': 'bf0d22904b98ad48a9cbf9251758ce74',
      "Access-Control-Allow-Origin": "*",
      'Accept': '*/*',
      'session': localUser.getString('token')!,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    Map<String, dynamic> userData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = userData['data'];
      return {
        'data': data['user']['employee_id'],
        'status': response.statusCode
      };
    } else {
      return {'data': userData['message'], 'status': response.statusCode};
    }
  }

  static Future<String?> signIn(String emailOrUsername, String password) async {
    final url = Uri.parse('http://$apiUrl/login');

    final Map<String, String> body = {
      'emailOrUsername': emailOrUsername,
      'password': password,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Group-Authorization': 'bf0d22904b98ad48a9cbf9251758ce74',
      "Access-Control-Allow-Origin": "*",
      'Accept': '*/*'
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    Map<String, dynamic> userData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      localUser.setString('token', userData['session']);
      return null;
    } else {
      return userData['message'];
    }
  }
}
