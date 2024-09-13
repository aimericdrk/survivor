import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utility {
  static List<String> tabName() {
    return [
      'Dashboard',
      'Coaches',
      'Customers',
      'Wardrobe',
      'Matches',
      'Tips',
      'Events'
    ];
  }

  static Icon tabIcon(int index) {
    return [
      const Icon(Icons.home, color: Colors.black),
      const Icon(Icons.people, color: Colors.black),
      const Icon(Icons.person, color: Colors.black),
      const Icon(Icons.bar_chart, color: Colors.black),
      const Icon(Icons.shopping_bag, color: Colors.black),
      const Icon(CupertinoIcons.arrow_2_circlepath, color: Colors.black),
      const Icon(Icons.lightbulb, color: Colors.black),
      const Icon(Icons.event, color: Colors.black),
    ][index];
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
