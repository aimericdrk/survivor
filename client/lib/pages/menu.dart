import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/auth/onboard.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/pages/subpages/coaches.dart';
import 'package:soul_connection/pages/subpages/customers.dart';
import 'package:soul_connection/pages/subpages/event.dart';
import 'package:soul_connection/pages/subpages/home.dart';
import 'package:soul_connection/pages/subpages/matches.dart';
import 'package:soul_connection/pages/subpages/tips.dart';
import 'package:soul_connection/pages/subpages/wardrobe.dart';
import 'package:soul_connection/utility/utility.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: Utility.tabName().length,
      vsync: this,
    );
  }

  Widget tabPage(int index) {
    return [
      const HomePage(),
      const CoachesPage(),
      const CustomersPage(),
      const WardrobePage(),
      const MatchesPage(),
      const TipsPage(),
      const EventPage(),
    ][index];
  }

  Widget tabButton(String title, int index) {
    return FittedBox(
      child: Text(
        title,
        style: TextStyle(
          color: tabIndex == index
              ? const Color(0xff0071cf)
              : const Color(0xff637695),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Soul Connection',
            style: TextStyle(
              color: Color(0xff3b546d),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {},
          ),
          sw(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: SizedBox(
              width: 25,
              height: 25,
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset(
                  'assets/usa.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          sw(20),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              localUser.clear();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OnBoardPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Transform.rotate(
                                  angle: -0.8,
                                  child: const Icon(
                                    CupertinoIcons.hand_raised_fill,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xff3b83c7),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: user!.profilePicture,
                  errorWidget: (context, url, error) {
                    return const Icon(
                      CupertinoIcons.person,
                      color: Colors.white,
                      size: 14,
                    );
                  },
                ),
              ),
            ),
          ),
          sw(20)
        ],
        flexibleSpace: Container(
          color: Colors.white,
          width: dw(context),
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 2,
                    color: const Color(0xffeaeef6),
                    width: dw(context),
                  ),
                ],
              ),
              SizedBox(
                width: dw(context) / 2.5,
                height: 90,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: const Color(0xff0071cf),
                  controller: tabController,
                  onTap: (int index) {
                    setState(() {
                      tabIndex = index;
                    });
                  },
                  tabs: [
                    for (int i = 0; i < Utility.tabName().length; i++)
                      Tab(
                        child: tabButton(Utility.tabName()[i], i),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: dw(context) <= 700 && !isWearOs(context)
          ? BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  tabIndex = index;
                });
              },
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              currentIndex: tabIndex,
              items: [
                for (int i = 0; i < Utility.tabName().length; i++)
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Utility.tabIcon(i),
                    label: Utility.tabName()[i],
                  ),
              ],
            )
          : null,
      body: SizedBox(
        height: dh(context),
        width: dw(context),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: tabPage(tabIndex),
          ),
        ),
      ),
    );
  }
}
