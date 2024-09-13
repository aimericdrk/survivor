class UserModel {
  String email;
  String name;
  String surname;
  String gender;
  String work;
  String lastSession;
  String employeeId;

  UserModel({
    required this.email,
    required this.name,
    required this.surname,
    required this.gender,
    required this.work,
    required this.lastSession,
    required this.employeeId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      gender: json['gender'],
      work: json['work'],
      employeeId: json['employee_id'],
      lastSession: json['lastConnection'] ?? 'Never',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'gender': gender,
      'work': work,
      'User_id': employeeId,
      'lastConnection': lastSession,
    };
  }
}

