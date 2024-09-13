import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/employees.module.dart';

class UserService {
  static Future<bool> fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://$apiUrl/api/me'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );
    if (response.statusCode == 200) {
      dynamic bodyUser = jsonDecode(response.body)['data'];
      if (bodyUser.containsKey("soul_employee")) {
        final userId = bodyUser['soul_employee']['employee_id'];
        final fetchEmployee = await http.get(
          Uri.parse('http://$apiUrl/soul_connection_api/employee/$userId'),
          headers: {
            'session': localUser.getString('token')!,
          },
        );
        if (fetchEmployee.statusCode == 200) {
          dynamic bodyUser = jsonDecode(fetchEmployee.body)['data'];
          user = EmployeeModel.fromJson(bodyUser);
        }
      }
      return true;
    } else {
      return false;
    }
  }
}
