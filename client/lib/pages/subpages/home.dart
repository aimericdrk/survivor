import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/pages/subpages/widgets/customers.graph.dart';
import 'package:soul_connection/pages/subpages/widgets/events.graph.dart';
import 'package:soul_connection/pages/subpages/widgets/map.graph.dart';
import 'package:soul_connection/pages/subpages/widgets/meeting.graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> countries = ['France'];

  String calculateAverageCustomersByCoach() {
    if (allCoaches.isEmpty) return '0';
    int totalCustomers =
        allCoaches.fold(0, (sum, coach) => sum + coach.assignedCustomer.length);
    return (totalCustomers / allCoaches.length).toStringAsFixed(1);
  }

  String calculateEvolutionOfEvent() {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime now = DateTime.now();

    int currentMonthEvents = allEvents.where((event) {
      DateTime eventDate = dateFormat.parse(event.date);
      return eventDate.month == now.month && eventDate.year == now.year;
    }).length;

    DateTime previousMonth = DateTime(now.year, now.month - 1);
    int previousMonthEvents = allEvents.where((event) {
      DateTime eventDate = dateFormat.parse(event.date);
      return eventDate.month == previousMonth.month &&
          eventDate.year == previousMonth.year;
    }).length;

    double percentageDifference = 0;
    if (previousMonthEvents > 0) {
      percentageDifference =
          ((currentMonthEvents - previousMonthEvents) / previousMonthEvents) *
              100;
    } else if (currentMonthEvents > 0) {
      percentageDifference = 100.0;
    }
    return percentageDifference.toStringAsFixed(1);
  }

  int index = 1;
  String currentDay = '30 Days';
  String currentDays = '30 Days';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dh(context),
      width: dw(context),
      child: SingleChildScrollView(
        child: Column(
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
                          'Dashboard',
                          style: TextStyle(
                            color: Color(0xff3b546d),
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      sh(3),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
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
                          width: 150,
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
                                Icons.calendar_month_outlined,
                                color: Color(0xff415a7e),
                                size: 15,
                              ),
                              sw(5),
                              const Text(
                                'Last 30 Days',
                                style: TextStyle(
                                  color: Color(0xff415a7e),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              sw(5),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xff415a7e),
                                size: 10,
                              ),
                              sw(5),
                            ],
                          ),
                        ),
                        sw(15),
                        Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xff0065b9),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.analytics_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              sw(5),
                              const Text(
                                'Reports',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sh(20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: dh(context) / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: const Color(0xffeaeef6), width: 2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: user!.work == 'Coach'
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, color: Colors.black),
                                Text('Only available for non coach users'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Customers Overview',
                                        style: TextStyle(
                                          color: Color(0xff3b546d),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      sh(3),
                                      const Text(
                                        'When customers have joined in the time.',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 30,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: const Color(0xffeaeef6),
                                          width: 2),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              index = 0;
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 38.5,
                                            color: index == 0
                                                ? const Color(0xffeaeef6)
                                                : Colors.white,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              '7 D',
                                              style: TextStyle(
                                                color: Color(0xff869cb7),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 2,
                                              color: const Color(0xffeaeef6),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  index = 1;
                                                });
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 35,
                                                color: index == 1
                                                    ? const Color(0xffeaeef6)
                                                    : Colors.white,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  '1 M',
                                                  style: TextStyle(
                                                    color: Color(0xff869cb7),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 35,
                                              width: 2,
                                              color: const Color(0xffeaeef6),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              index = 2;
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 38.5,
                                            color: index == 2
                                                ? const Color(0xffeaeef6)
                                                : Colors.white,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              '3 M',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff869cb7),
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              sh(20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Customers',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      Text(
                                        allCustomers.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Color(0xff26efc8),
                                            size: 10,
                                          ),
                                          Text(
                                            '100%',
                                            style: TextStyle(
                                              color: Color(0xff26efc8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Doing meetings',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      Text(
                                        '${allCustomers.where((customer) {
                                          DateTime now = DateTime.now();
                                          int currentMonth = now.month;
                                          int currentYear = now.year;
                                          return customer
                                                  .encouters.isNotEmpty &&
                                              customer.encouters
                                                  .any((encounter) {
                                                DateTime encounterDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .parse(encounter.date);
                                                return encounterDate.month ==
                                                        currentMonth &&
                                                    encounterDate.year ==
                                                        currentYear;
                                              });
                                        }).length}%',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      sh(5),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward_outlined,
                                            color: Color(0xfffc4648),
                                            size: 10,
                                          ),
                                          Text(
                                            '-100%',
                                            style: TextStyle(
                                              color: Color(0xfffc4648),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Customers by coach',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      Text(
                                        calculateAverageCustomersByCoach(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  sw(dw(context) / 5)
                                ],
                              ),
                              sh(40),
                              SizedBox(
                                width: dw(context) / 1,
                                height: dh(context) / 4.4,
                                child: CustomersGraph(
                                  date: index,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                sw(20),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: dh(context) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xffeaeef6), width: 2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: user!.work == 'Coach'
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, color: Colors.black),
                                Text('Only available for non coach users'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Events',
                                        style: TextStyle(
                                          color: Color(0xff3b546d),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      sh(3),
                                      const Text(
                                        'Our events and their status.',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    CupertinoIcons.question_circle,
                                    color: Color.fromARGB(255, 224, 224, 224),
                                    size: 14,
                                  ),
                                ],
                              ),
                              sh(20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Monthly',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      Text(
                                        '${((allEvents.where((event) {
                                              final DateFormat dateFormat =
                                                  DateFormat('dd-MM-yyyy');
                                              DateTime now = DateTime.now();
                                              DateTime eventDate =
                                                  dateFormat.parse(event.date);
                                              return eventDate.month ==
                                                  now.month;
                                            }).length / allEvents.length) * 100).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (calculateEvolutionOfEvent() ==
                                              '0.0')
                                            const Icon(
                                              CupertinoIcons.minus,
                                              color: Colors.grey,
                                              size: 10,
                                            )
                                          else
                                            const Icon(
                                              Icons.arrow_downward,
                                              color: Color(0xfffc4648),
                                              size: 10,
                                            ),
                                          Text(
                                            '${calculateEvolutionOfEvent()}%',
                                            style: TextStyle(
                                              color:
                                                  calculateEvolutionOfEvent() ==
                                                          '0.0'
                                                      ? Colors.grey
                                                      : const Color(0xfffc4648),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Weekly',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      const Text(
                                        '15%',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      sh(5),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Color(0xff26efc8),
                                            size: 10,
                                          ),
                                          Text(
                                            '12.48%',
                                            style: TextStyle(
                                              color: Color(0xff26efc8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Daily (Avg)',
                                        style: TextStyle(
                                          color: Color(0xff8ca1ba),
                                          fontSize: 12,
                                        ),
                                      ),
                                      sh(5),
                                      const Text(
                                        '34',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  sw(10)
                                ],
                              ),
                              sh(40),
                              SizedBox(
                                height: dh(context) / 4.4,
                                width: dw(context) / 1,
                                child: const EventGraph(),
                              )
                            ],
                          ),
                  ),
                ),
              ],
            ),
            sh(20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: dh(context) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xffeaeef6), width: 2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: user!.work == 'Coach'
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, color: Colors.black),
                                Text('Only available for non coach users'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Customers by Country',
                                        style: TextStyle(
                                          color: Color(0xff3b546d),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffeaeef6),
                                            width: 2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: currentDay,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.black),
                                          elevation: 16,
                                          iconSize: 14,
                                          focusColor: const Color(0xfff2f2f2),
                                          dropdownColor: Colors.white,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              currentDay = value!;
                                            });
                                          },
                                          items: [
                                            '30 Days',
                                            '60 Days',
                                            '90 Days'
                                          ]
                                              .toList()
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  color: Color(0xff415a7e),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sh(20),
                              SizedBox(
                                height: dh(context) / 5,
                                width: dw(context) / 1,
                                child: const SupportedCountriesMap(),
                              ),
                              sh(10),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: countries.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: dw(context) / 4,
                                        child: Text(
                                          countries[index],
                                          style: const TextStyle(
                                            color: Color(0xff95a9c0),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          allCustomers.length.toString(),
                                          style: const TextStyle(
                                            color: Color(0xff3b546d),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '100%',
                                        style: TextStyle(
                                          color: Color(0xff95a9c0),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                  ),
                ),
                sw(20),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: dh(context) / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: const Color(0xffeaeef6), width: 2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: user!.work == 'Coach'
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, color: Colors.black),
                                Text('Only available for non coach users'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Meeting top sources',
                                        style: TextStyle(
                                          color: Color(0xff3b546d),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffeaeef6),
                                            width: 2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: currentDays,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.black),
                                          elevation: 16,
                                          iconSize: 14,
                                          focusColor: const Color(0xfff2f2f2),
                                          dropdownColor: Colors.white,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              currentDays = value!;
                                            });
                                          },
                                          items: [
                                            '30 Days',
                                            '60 Days',
                                            '90 Days'
                                          ]
                                              .toList()
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  color: Color(0xff415a7e),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sh(20),
                              SizedBox(
                                height: dh(context) / 3,
                                width: dw(context) / 1,
                                child: const PieChartSample(),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
