import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/pages/menu.dart';
import 'package:soul_connection/provider/auth.service.dart';
import 'package:soul_connection/provider/coachs.service.dart';
import 'package:soul_connection/provider/customers.service.dart';
import 'package:soul_connection/provider/encounters.service.dart';
import 'package:soul_connection/provider/events.service.dart';
import 'package:soul_connection/provider/tips.service.dart';
import 'package:soul_connection/provider/user.service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> {
  late TextEditingController _email;
  late TextEditingController _password;
  bool loader = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isWearOs(context)) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                decoration:
                    const InputDecoration(hintText: 'Email or username'),
              ),
              TextField(
                obscureText: true,
                controller: _password,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              sh(20),
              GestureDetector(
                onTap: () async {
                  if (!loader) {
                    setState(() {
                      loader = true;
                    });
                    String? user =
                        await AuthService.signIn(_email.text, _password.text);
                    if (user == null) {
                      await Future.wait([
                        UserService.fetchUsers().then((value) {
                          CustomersService.fetchCustomers();
                          CoachsService.fetchEmployees();
                          EncounterService.fetchEncounter();
                          TipsService.fetchTips();
                          EventService.fetchEvent();
                        }),
                      ]);
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const MenuPage(),
                        ),
                        (route) => false,
                      );
                    } else {
                      setState(() {
                        loader = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 5),
                          content: Center(
                            child: Text(
                              user,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: loader
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f6fa),
        elevation: 0,
        title: const Text(
          "Sign in",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        width: dw(context),
        height: dh(context),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xffeaeef6), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
            ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Email or username'),
            ),
            Container(
              height: 50,
            ),
            TextField(
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            Container(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                if (!loader) {
                  setState(() {
                    loader = true;
                  });
                  String? user =
                      await AuthService.signIn(_email.text, _password.text);
                  if (user == null) {
                    await Future.wait([
                      UserService.fetchUsers().then((value) {
                        CustomersService.fetchCustomers();
                        CoachsService.fetchEmployees();
                      }),
                      TipsService.fetchTips(),
                      EventService.fetchEvent(),
                    ]);
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MenuPage(),
                      ),
                      (route) => false,
                    );
                  } else {
                    setState(() {
                      loader = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blue,
                        duration: const Duration(seconds: 5),
                        content: Center(
                          child: Text(
                            user,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Container(
                height: 70,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xffeaeef6), width: 2),
                ),
                alignment: Alignment.center,
                child: loader
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color(0xff415a7e),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
