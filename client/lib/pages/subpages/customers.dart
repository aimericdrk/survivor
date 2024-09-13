import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/customer.module.dart';
import 'package:soul_connection/models/employees.module.dart';
import 'package:soul_connection/models/encounter.module.dart';
import 'package:soul_connection/models/payement.module.dart';
import 'package:soul_connection/pages/subpages/interface/mouse_pointer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage>
    with HoverMixin<CustomersPage> {
  CustomerModel? currentCustomer;

  String fillPaymentTable(PayementModel payment, int index) {
    if (index == 0) {
      return DateFormat('dd MMMM yyyy').format(DateTime.parse(payment.date));
    }
    if (index == 1) return '-\$${payment.amount}';
    if (index == 2) return payment.paymentMethod;
    if (index == 3) return payment.comment;
    return '';
  }

  String fillEncouterTable(EncounterModel encounter, int index) {
    if (index == 0) {
      return DateFormat('dd MMMM yyyy').format(DateTime.parse(encounter.date));
    }
    if (index == 1) return '${encounter.rating}/5';
    if (index == 2) return encounter.comment;
    if (index == 3) return encounter.source;
    return '';
  }

  String getImage(String payment) {
    if (payment == 'PayPal') return 'assets/paypal.png';
    if (payment == 'Credit Card') return 'assets/creditcard.png';
    if (payment == 'Bank Transfer') return 'assets/bank1.png';
    return 'assets/mastercard.png';
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentCustomer != null
                          ? 'Customer Details'
                          : 'Customers List',
                      style: const TextStyle(
                        color: Color(0xff3b546d),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  sh(3),
                  if (currentCustomer == null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'You have total ${filteredCustomers.length} customers.',
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
                    GestureDetector(
                      onTap: () {
                        if (currentCustomer != null) {
                          setState(() {
                            currentCustomer = null;
                          });
                        }
                      },
                      child: Container(
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
                            if (currentCustomer == null)
                              const Icon(
                                Icons.cloud_download_outlined,
                                color: Color(0xff415a7e),
                                size: 15,
                              )
                            else
                              const Icon(
                                Icons.arrow_back,
                                color: Color(0xff415a7e),
                                size: 15,
                              ),
                            sw(2),
                            Text(
                              currentCustomer != null ? 'Back' : 'Export',
                              style: const TextStyle(
                                color: Color(0xff415a7e),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            sw(5),
                          ],
                        ),
                      ),
                    ),
                    if (currentCustomer == null) sw(15),
                    if (currentCustomer == null)
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
        if (currentCustomer == null)
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
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
                            SizedBox(
                              width: 230,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff9da9bd),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff9da9bd),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: Text(
                                'Number of customers',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff9da9bd),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
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
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentCustomer = customer;
                          });
                        },
                        child: Container(
                          width: dw(context),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Container(
                                height: 2,
                                width: dw(context),
                                color: const Color(0xffeaeef6),
                              ),
                              Container(
                                height: 50,
                                width: dw(context),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: CachedNetworkImage(
                                                      imageUrl: customer
                                                          .profilePicture,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        color: [
                                                          const Color(
                                                              0xff748bff),
                                                          const Color(
                                                              0xfffc403c),
                                                          const Color(
                                                              0xff253384),
                                                          const Color(
                                                              0xffffb05f),
                                                          const Color(
                                                              0xff0064b9),
                                                        ][index % 5],
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          (customer.name
                                                                      .substring(
                                                                          0,
                                                                          1) +
                                                                  customer
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
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                sw(10),
                                                Text(
                                                  '${customer.name} ${customer.surname}',
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
                                            width: 230,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              customer.email,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff9da9bd),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              customer.phoneNumber,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff9da9bd),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            width: 170,
                                            alignment: Alignment.centerLeft,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox(
                                                width: 70,
                                                height: 30,
                                                child: Image.asset(
                                                  getImage(customer.payements
                                                      .last.paymentMethod),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Icon(Icons.more_horiz),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: dh(context) / 1.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: const Color(0xffeaeef6), width: 2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: CachedNetworkImage(
                            imageUrl: currentCustomer!.profilePicture,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              return Container(
                                color: [
                                  const Color(0xff748bff),
                                  const Color(0xfffc403c),
                                  const Color(0xff253384),
                                  const Color(0xffffb05f),
                                  const Color(0xff0064b9),
                                ][1 % 5],
                                alignment: Alignment.center,
                                child: Text(
                                  (currentCustomer!.name.substring(0, 1) +
                                          currentCustomer!.surname
                                              .substring(0, 1))
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      sh(12),
                      Text(
                        '${currentCustomer!.name} ${currentCustomer!.surname}',
                        style: const TextStyle(
                          color: Color(0xff3b546d),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      sh(20),
                      Container(
                        height: 2,
                        width: dw(context) / 1,
                        color: const Color(0xffeaeef6),
                      ),
                      sh(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'mailto:${currentCustomer!.email}'));
                            },
                            child: const Icon(
                              Icons.email_outlined,
                              size: 15,
                              color: Color(0xff3b546d),
                            ),
                          ),
                          sw(20),
                          const Icon(
                            Icons.bookmark_border_rounded,
                            color: Color(0xff3b546d),
                            size: 15,
                          )
                        ],
                      ),
                      sh(15),
                      Container(
                        height: 2,
                        width: dw(context) / 1,
                        color: const Color(0xffeaeef6),
                      ),
                      sh(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                currentCustomer!.encouters.length.toString(),
                                style: const TextStyle(
                                  color: Color(0xff3b546d),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'Total\nEncounters',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 110, 132, 153),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${currentCustomer!.encouters.fold(0, (previousValue, element) => previousValue + element.rating)}',
                                style: const TextStyle(
                                  color: Color(0xff3b546d),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'Positives',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 110, 132, 153),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                currentCustomer!.encouters
                                    .where((element) {
                                      String today = DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now());
                                      return today == element.date;
                                    })
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  color: Color(0xff3b546d),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'In Progress',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 110, 132, 153),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      sh(15),
                      Container(
                        height: 2,
                        width: dw(context) / 1,
                        color: const Color(0xffeaeef6),
                      ),
                      sh(15),
                      SizedBox(
                        width: dw(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SHORT DETAILS',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'User ID:',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currentCustomer!.userId.toString(),
                              style: const TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            sh(10),
                            const Text(
                              'Email:',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currentCustomer!.email,
                              style: const TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            sh(10),
                            const Text(
                              'Address:',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currentCustomer!.address,
                              style: const TextStyle(
                                color: Color(0xff3b546d),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            sh(10),
                            const Text(
                              'Last Activity:',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy').format(DateTime.parse(
                                  currentCustomer!.encouters.last.date)),
                              style: const TextStyle(
                                color: Color(0xff3b546d),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            sh(10),
                            const Text(
                              'Coach:',
                              style: TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              allCoaches
                                  .firstWhere(
                                    (element) =>
                                        element.id == currentCustomer!.userId,
                                    orElse: () => EmployeeModel(
                                      id: 0,
                                      name: 'No Coach Assigned',
                                      gender: '',
                                      surname: 'Unknown',
                                      work: '',
                                      lastSession: '',
                                      employeeId: '',
                                      assignedCustomer: [],
                                      email: 'Unknown',
                                      profilePicture: 'Unknown',
                                      birthDate: '',
                                    ),
                                  )
                                  .name,
                              style: const TextStyle(
                                color: Color(0xff3b546d),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sw(20),
              Expanded(
                flex: 3,
                child: Container(
                  height: dh(context) / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: const Color(0xffeaeef6), width: 2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Meetings',
                        style: TextStyle(
                          color: Color(0xff3b546d),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      sh(10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xffeaeef6),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Rating',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Comment',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Source',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            for (int i = 0;
                                i < currentCustomer!.encouters.length && i < 5;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    width: dw(context),
                                    height: 2,
                                    color: const Color(0xffeaeef6),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.5,
                                      horizontal: 10,
                                    ),
                                    child: SizedBox(
                                      height: 25,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fillEncouterTable(
                                                  currentCustomer!.encouters[i],
                                                  0),
                                              style: const TextStyle(
                                                color: Color(0xff3382c6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  for (int y = 0; y < 5; y++)
                                                    Icon(
                                                      currentCustomer!
                                                                  .encouters[i]
                                                                  .rating >
                                                              y
                                                          ? Icons.star
                                                          : Icons.star_outline,
                                                      color: Colors.black,
                                                      size: 15,
                                                    )
                                                ],
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              fillEncouterTable(
                                                  currentCustomer!.encouters[i],
                                                  2),
                                              style: const TextStyle(
                                                  color: Color(0xff3b546d),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fillEncouterTable(
                                                  currentCustomer!.encouters[i],
                                                  3),
                                              style: TextStyle(
                                                color: [
                                                  const Color(0xfffdb000),
                                                  const Color(0xff00eab9),
                                                  const Color(0xff00bedd)
                                                ][i % 3],
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
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
                      sh(15),
                      const Text(
                        'Payments history',
                        style: TextStyle(
                          color: Color(0xff3b546d),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      sh(10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xffeaeef6),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Payment method',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Comment',
                                      style: TextStyle(
                                        color: Color(0xff9da9bd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            for (int i = 0;
                                i < currentCustomer!.payements.length && i < 4;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    width: dw(context),
                                    height: 2,
                                    color: const Color(0xffeaeef6),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: SizedBox(
                                      height: 25,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fillPaymentTable(
                                                  currentCustomer!.payements[i],
                                                  0),
                                              style: const TextStyle(
                                                color: Color(0xff3382c6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  getImage(currentCustomer!
                                                      .payements[i]
                                                      .paymentMethod),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fillPaymentTable(
                                                  currentCustomer!.payements[i],
                                                  1),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fillPaymentTable(
                                                  currentCustomer!.payements[i],
                                                  3),
                                              style: const TextStyle(
                                                color: Color(0xff879db8),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
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
                    ],
                  ),
                ),
              )
            ],
          )
      ],
    );
  }
}
