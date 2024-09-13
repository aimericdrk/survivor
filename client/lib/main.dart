import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_connection/auth/onboard.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/pages/menu.dart';
import 'package:soul_connection/provider/coachs.service.dart';
import 'package:soul_connection/provider/customers.service.dart';
import 'package:soul_connection/provider/encounters.service.dart';
import 'package:soul_connection/provider/events.service.dart';
import 'package:soul_connection/provider/tips.service.dart';
import 'package:soul_connection/provider/user.service.dart';
import 'package:soul_connection/watch-wrapper/watch_os.dart';
import 'package:soul_connection/watch-wrapper/wear_os.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localUser = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (localUser.containsKey('token')) {
      fetchData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([
        UserService.fetchUsers().then((value) {
          CustomersService.fetchCustomers();
          CoachsService.fetchEmployees();
          EncounterService.fetchEncounter();
          TipsService.fetchTips();
          EventService.fetchEvent();
        }),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      if (!kIsWeb && !Platform.isAndroid) WatchOSWrapper.sendDataToAppleWatch();
      if (!kIsWeb && !Platform.isAndroid) WearOSWrapper.sendDataToWearOs();
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  Widget page() {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Soul Connection',
              style: TextStyle(
                fontSize: dw(context) * 0.05,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
      );
    } else if (localUser.containsKey('token')) {
      return const MenuPage();
    } else {
      return const OnBoardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soul Connection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffa5b6ff),
            primary: const Color(0xffebeeff)),
        useMaterial3: true,
      ),
      home: page(),
    );
  }
}
