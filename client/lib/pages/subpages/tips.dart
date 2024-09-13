import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/pages/subpages/interface/mouse_pointer.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> with HoverMixin<TipsPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dh(context),
      width: dw(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sh(10),
          SizedBox(
            width: dw(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tips for Coaches',
                        style: TextStyle(
                          color: Color(0xff3b546d),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sh(40),
          SizedBox(
            height: dh(context) - 183,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allTips.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xffeaeef6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        collapsedIconColor: Colors.black,
                        title: Text(
                          allTips[index].title,
                          style: const TextStyle(
                            color: Color(0xff3b546d),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.all(0),
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 2,
                                color: const Color(0xffeaeef6),
                                width: dw(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 10, top: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    allTips[index].tips,
                                    style: const TextStyle(
                                      color: Color(0xff3b546d),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
