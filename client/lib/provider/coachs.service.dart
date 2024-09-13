import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/employees.module.dart';

class CoachsService {
  static Future<bool> fetchEmployees() async {
    final employees = await http.get(
      Uri.parse('http://$apiUrl/soul_connection_api/employee'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );
    final sessions = await http.get(
      Uri.parse('http://$apiUrl/api/users'),
      headers: {
        'session': localUser.getString('token')!,
      },
    );
    if (employees.statusCode == 200 && sessions.statusCode == 200) {
      List<dynamic> bodyEmployees = jsonDecode(employees.body)['data'];
      allCoaches = bodyEmployees
          .map((json) => EmployeeModel.fromJson(json))
          .where((EmployeeModel e) => e.work == 'Coach')
          .toList();
      List<dynamic> bodySessions = jsonDecode(sessions.body)['data'];
      for (var element in allCoaches) {
        element.lastSession = bodySessions.firstWhere(
            (element2) => element2['email'] == element.email,
            orElse: () => {'lastConnection': 'Never'})['lastConnection'];
      }
      return true;
    } else {
      return false;
    }
  }
}
