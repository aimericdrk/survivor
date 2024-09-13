import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/auth/signup.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/employees.module.dart';
import 'package:soul_connection/pages/subpages/widgets/edit_users.dart';

class CoachesPage extends StatefulWidget {
  const CoachesPage({super.key});

  @override
  State<CoachesPage> createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  String fillTable(EmployeeModel employee, int index) {
    if (index == 1) return '${employee.name} ${employee.surname}';
    if (index == 2) return employee.birthDate;
    if (index == 3) {
      return user!.work != 'Coach' ? 'Edit list ...' : 'View list ...';
    }
    if (index == 4) return employee.lastSession;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sh(10),
        SizedBox(
          width: dw(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Coaches List',
                      style: TextStyle(
                        color: Color(0xff3b546d),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  sh(3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'You have total ${allCoaches.length} coaches.',
                      style: const TextStyle(
                        color: Color(0xff708dab),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color(0xffeaeef6), width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          sw(5),
                          const Icon(
                            Icons.cloud_download_outlined,
                            color: Color(0xff415a7e),
                            size: 15,
                          ),
                          sw(2),
                          const Text(
                            'Export',
                            style: TextStyle(
                              color: Color(0xff415a7e),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          sw(5),
                        ],
                      ),
                    ),
                    sw(15),
                    GestureDetector(
                      onTap: () {
                        if (user!.work == 'Coach') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xff748bff),
                              content: Text(
                                  'You do not have permission to add customers'),
                            ),
                          );
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: const SignUpPage(),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xff0065b9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        sh(30),
        Container(
          width: dw(context),
          height: kIsWeb ? dh(context) / 1.3 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(color: const Color(0xffeaeef6), width: 2),
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                width: dw(context),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: const Color(0xffeaeef6), width: 2),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bulk Action',
                                style: TextStyle(
                                  color: Color(0xff8fa4bd),
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                        sw(15),
                        Container(
                          height: 40,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xfffafafc),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: const Color(0xffeaeef6), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Color(0xff9da9bd),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          size: 20,
                          color: Color(0xff415a7e),
                        ),
                        sw(15),
                        Container(
                          height: 40,
                          width: 1,
                          color: const Color(0xffeaeef6),
                        ),
                        sw(15),
                        const Icon(
                          Icons.filter_list_sharp,
                          size: 17,
                          color: Color(0xff415a7e),
                        ),
                        sw(15),
                        const Icon(
                          Icons.settings,
                          size: 17,
                          color: Color(0xff415a7e),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                width: dw(context),
                color: const Color(0xffeaeef6),
              ),
              Container(
                height: 30,
                width: dw(context),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      activeColor: const Color(0xff0065b9),
                    ),
                    SizedBox(
                      height: 30,
                      width: dw(context) - 106,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 200,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Coach',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff9da9bd),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff9da9bd),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9da9bd),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Last Connection',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9da9bd),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Number of customers',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9da9bd),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Actions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9da9bd),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: dw(context),
                height: dh(context) / 1.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allCoaches.length,
                  itemBuilder: (context, index) {
                    final employee = allCoaches[index];
                    return Column(
                      children: [
                        Container(
                          height: 2,
                          width: dw(context),
                          color: const Color(0xffeaeef6),
                        ),
                        Container(
                          height: 50,
                          width: dw(context),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                                activeColor: const Color(0xff0065b9),
                              ),
                              SizedBox(
                                height: 30,
                                width: dw(context) - 106,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          sw(10),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Builder(
                                              builder: (context) {
                                                return SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        employee.profilePicture,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      color: [
                                                        const Color(0xff748bff),
                                                        const Color(0xfffc403c),
                                                        const Color(0xff253384),
                                                        const Color(0xffffb05f),
                                                        const Color(0xff0064b9),
                                                      ][index % 5],
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          (employee.name
                                                                      .substring(
                                                                          0,
                                                                          1) +
                                                                  employee
                                                                      .surname
                                                                      .substring(
                                                                          0, 1))
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          sw(10),
                                          Text(
                                            '${employee.name} ${employee.surname}',
                                            style: const TextStyle(
                                              color: Color(0xff3b546d),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 250,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        employee.email,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff9da9bd),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        '+33 6 77 88 99 00',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff9da9bd),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        employee.lastSession,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff9da9bd),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        employee.assignedCustomer.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff9da9bd),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => EditCustomers(
                                            employee: allCoaches[index],
                                            permission: user!.work != 'Coach',
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.more_horiz),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
