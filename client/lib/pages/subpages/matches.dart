import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/customer.module.dart';
import 'package:soul_connection/pages/subpages/interface/mouse_pointer.dart';
import 'package:soul_connection/pages/subpages/widgets/drop_down_button.dart';
import 'package:soul_connection/pages/subpages/widgets/progress_circle.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage>
    with HoverMixin<MatchesPage> {
  CustomerModel firstCustomer = filteredCustomers.isNotEmpty
      ? filteredCustomers.first
      : CustomerModel(
          userId: 1,
          email: '',
          name: '',
          surname: '',
          birthDate: '',
          gender: '',
          description: '',
          astrologicalSign: '',
          phoneNumber: '',
          address: '',
          clothes: [],
          profilePicture: '',
          payements: [],
          encouters: [],
        );
  CustomerModel secondCustomer = filteredCustomers.length > 1
      ? filteredCustomers[1]
      : CustomerModel(
          userId: 1,
          email: '',
          name: '',
          surname: '',
          birthDate: '',
          gender: '',
          description: '',
          astrologicalSign: '',
          phoneNumber: '',
          address: '',
          clothes: [],
          profilePicture: '',
          payements: [],
          encouters: [],
        );

  List<String> signs = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  List<List<int>> compatibilite = [
    [90, 60, 85, 50, 95, 40, 75, 30, 80, 35, 70, 45],
    [60, 90, 55, 80, 50, 95, 45, 85, 40, 75, 35, 70],
    [85, 55, 90, 60, 80, 50, 95, 45, 75, 40, 85, 35],
    [50, 80, 60, 90, 55, 85, 45, 95, 40, 75, 35, 85],
    [95, 50, 80, 55, 90, 60, 85, 45, 95, 40, 75, 35],
    [40, 95, 50, 85, 60, 90, 55, 80, 45, 95, 40, 75],
    [75, 45, 95, 45, 85, 55, 90, 60, 85, 55, 95, 45],
    [30, 85, 45, 95, 45, 80, 60, 90, 55, 85, 45, 95],
    [80, 40, 75, 40, 95, 45, 85, 55, 90, 60, 85, 55],
    [35, 75, 40, 75, 40, 95, 55, 85, 60, 90, 55, 85],
    [70, 35, 85, 35, 75, 40, 95, 45, 85, 55, 90, 60],
    [45, 70, 35, 85, 35, 75, 45, 95, 55, 85, 60, 90],
  ];

  int calculerCompatibilite(String signe1, String signe2) {
    int index1 = signs.indexOf(signe1);
    int index2 = signs.indexOf(signe2);

    if (index1 == -1 || index2 == -1) {
      return 0;
    }

    return compatibilite[index1][index2];
  }

  GlobalKey key = GlobalKey();

  Widget profilePic(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        sh(55),
        Builder(
          builder: (context) {
            return MouseRegion(
              onEnter: (event) {
                final renderBox = context.findRenderObject() as RenderBox;
                onHoverCard(event, index, renderBox);
              },
              onHover: (event) {
                final renderBox = context.findRenderObject() as RenderBox;
                onHoverCard(event, index, renderBox);
              },
              onExit: onExit,
              child: Transform(
                transform: hoveredIndex == index
                    ? getTransformMatrix()
                    : Matrix4.identity(),
                alignment: FractionalOffset.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: !kIsWeb
                      ? 80
                      : (((dw(context) / 10) > 140 ? 140 : (dw(context) / 10)) +
                          (hoveredIndex != index ? 0 : 40)),
                  width: !kIsWeb
                      ? 80
                      : (((dw(context) / 10) > 140 ? 140 : (dw(context) / 10)) +
                          (hoveredIndex != index ? 0 : 40)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: index == 0
                        ? firstCustomer.profilePicture
                        : secondCustomer.profilePicture,
                  ),
                ),
              ),
            );
          },
        ),
        sh(20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: kIsWeb ? 320 : 335,
          height: 30,
          child: CustomerDropdown(
            onCustomerChange: (CustomerModel currentCustomer) {
              setState(() {
                if (index == 0) firstCustomer = currentCustomer;
                if (index == 1) secondCustomer = currentCustomer;
                key = GlobalKey();
              });
            },
          ),
        ),
        sh(15),
        Text(
          index == 0
              ? firstCustomer.astrologicalSign
              : secondCustomer.astrologicalSign,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filteredCustomers.length <= 1) {
      return const Center(
        child: Text('No customers found'),
      );
    }
    return Container(
      height: dh(context) / 1.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffeaeef6), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            sw(20),
            profilePic(0),
            Builder(
              builder: (context) {
                return MouseRegion(
                  onEnter: (event) {
                    final renderBox = context.findRenderObject() as RenderBox;
                    onHoverCard(event, 2, renderBox);
                  },
                  onHover: (event) {
                    final renderBox = context.findRenderObject() as RenderBox;
                    onHoverCard(event, 2, renderBox);
                  },
                  onExit: onExit,
                  child: Transform(
                    transform: hoveredIndex == 2
                        ? getTransformMatrix()
                        : Matrix4.identity(),
                    alignment: FractionalOffset.center,
                    child: CircleProgressIndicator(
                      key: key,
                      hoveredIndex: hoveredIndex,
                      compatibility: calculerCompatibilite(
                        firstCustomer.astrologicalSign,
                        secondCustomer.astrologicalSign,
                      ),
                    ),
                  ),
                );
              },
            ),
            profilePic(1),
            sw(20),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const double step = 20;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
