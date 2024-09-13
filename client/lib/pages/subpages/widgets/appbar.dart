import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';

Widget appBar(BuildContext context, String title) {
  if (kIsWeb) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sh(52),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: dw(context) * 0.028,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
            ),
          ),
        ),
        sh(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            height: 1.5,
            color: Colors.black,
            width: dw(context),
          ),
        ),
        sh(20),
      ],
    );
  }
  return const SizedBox.shrink();
}
