import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/encounter.module.dart';
import 'package:soul_connection/models/payement.module.dart';

class CustomerModel {
  final int userId;
  final String email;
  final String name;
  final String surname;
  final String birthDate;
  final String gender;
  final String description;
  final String astrologicalSign;
  final String phoneNumber;
  final String address;
  final String profilePicture;
  final List<Map<String, dynamic>> clothes;
  final List<PayementModel> payements;
  final List<EncounterModel> encouters;

  CustomerModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.gender,
    required this.description,
    required this.astrologicalSign,
    required this.phoneNumber,
    required this.address,
    required this.clothes,
    required this.profilePicture,
    required this.payements,
    required this.encouters,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    List<EncounterModel> encounters = [];
    List<PayementModel> payments = [];
    List<Map<String, dynamic>> clothes = [];
    if (json['encounters'] != null && json['encounters'] is Iterable) {
      encounters = (json['encounters'] as List)
          .map((encounter) => EncounterModel.fromJson(encounter))
          .toList();
    }
    if (json['payments_history'] != null &&
        json['payments_history'] is Iterable) {
      payments = (json['payments_history'] as List)
          .map((payments) => PayementModel.fromJson(payments))
          .toList();
    }
    if (json['clothes'] != null && json['clothes'] is Iterable) {
      clothes = (json['clothes'] as List)
          .map<Map<String, dynamic>>((e) => e)
          .toList();
    }

    return CustomerModel(
      userId: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      description: json['description'],
      astrologicalSign: json['astrological_sign'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      clothes: clothes,
      profilePicture:
          'http://$apiUrl/soul_connection_api/customer_image/${json['id']}.png?session=${localUser.getString('token')!}',
      payements: payments,
      encouters: encounters,
    );
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> clothesJson = clothes.map((e) => e).toList();
    List<Map<String, dynamic>> payementsJson =
        payements.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> encountersJson =
        encouters.map((e) => e.toJson()).toList();

    return {
      'id': userId,
      'email': email,
      'name': name,
      'surname': surname,
      'birth_date': birthDate,
      'gender': gender,
      'description': description,
      'astrological_sign': astrologicalSign,
      'phone_number': phoneNumber,
      'address': address,
      'clothes': clothesJson,
      'payments_history': payementsJson,
      'encounters': encountersJson,
    };
  }
}
