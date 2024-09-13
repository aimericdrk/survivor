import 'package:soul_connection/constants/constants.dart';

class EmployeeModel {
  int id;
  String email;
  String name;
  String surname;
  String birthDate;
  String gender;
  String work;
  String lastSession;
  String employeeId;
  String profilePicture;
  List<int> assignedCustomer;

  EmployeeModel({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.gender,
    required this.work,
    required this.lastSession,
    required this.employeeId,
    required this.assignedCustomer,
    required this.profilePicture,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    List<int> assignedCustomer = [];
    if (json.containsKey('assigned_customers') &&
        json['assigned_customers'] != null) {
      assignedCustomer = List<String>.from(json['assigned_customers'])
          .map((e) => int.parse(e))
          .toList();
    }
    return EmployeeModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      work: json['work'],
      employeeId: json['employee_id'],
      lastSession: json['lastConnection'] ?? 'Never',
      assignedCustomer: assignedCustomer,
      profilePicture:
          'http://$apiUrl/soul_connection_api/customer_image/${json['id']}.png?session=${localUser.getString('token')!}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'birth_date': birthDate,
      'gender': gender,
      'work': work,
      'employee_id': employeeId,
      'lastConnection': lastSession,
      'assigned_customers': assignedCustomer,
      'profilePicture': profilePicture,
    };
  }
}
