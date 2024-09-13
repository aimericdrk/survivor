import 'package:http/http.dart' as http;
import 'package:soul_connection/constants/constants.dart';

class AssignCustomers {
  static Future<String> assignEmployee(
    List<int> customersId,
    int coachId,
  ) async {
    final url = Uri.parse('http://$apiUrl/api/assign');

    final Map<String, String> headers = {
      'session': localUser.getString('token')!,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final Map<String, String> body = {
      'customerId': '$customersId',
      'coachId': '$coachId',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      _updateCoachAssignedCustomers(coachId, customersId);
      return 'Successfully assigned';
    } else {
      return 'Failed to assign: ${response.body}';
    }
  }

  static Future<String> unAssignEmployee(
    List<int> customersId,
    int coachId,
  ) async {
    final url = Uri.parse('http://$apiUrl/api/unassign');

    final Map<String, String> headers = {
      'session': localUser.getString('token')!,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final Map<String, String> body = {
      'customerId': '$customersId',
      'coachId': '$coachId',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      _updateCoachAssignedCustomers(coachId, customersId);
      return 'Successfully assigned';
    } else {
      return 'Failed to assign: ${response.body}';
    }
  }

  static void _updateCoachAssignedCustomers(
      int coachId, List<int> newAssignedCustomers) {
    for (var coach in allCoaches) {
      if (coach.id == coachId) {
        for (int customerId in newAssignedCustomers) {
          if (!coach.assignedCustomer.contains(customerId)) {
            coach.assignedCustomer.add(customerId);
          } else {
            coach.assignedCustomer.remove(customerId);
          }
        }
        break;
      }
    }
  }
}
