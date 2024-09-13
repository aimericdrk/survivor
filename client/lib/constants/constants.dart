import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_connection/models/customer.module.dart';
import 'package:soul_connection/models/employees.module.dart';
import 'package:soul_connection/models/encounter.module.dart';
import 'package:soul_connection/models/event.module.dart';
import 'package:soul_connection/models/tips.module.dart';

late SharedPreferences localUser;

List<CustomerModel> allCustomers = [];

List<CustomerModel> filteredCustomers = [];

EmployeeModel? user;

List<EmployeeModel> allCoaches = [];

List<TipsModel> allTips = [];

List<EventModel> allEvents = [];

List<EncounterModel> allEncounters = [];

String apiUrl = 'your_api_url';

double dh(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double dw(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Widget sh(double height) {
  return Container(height: height);
}

Widget sw(double width) {
  return Container(width: width);
}

const channel = MethodChannel('com.soul.connection');

bool isWearOs(BuildContext context) {
  return dw(context) < 300 && dh(context) < 300;
}
