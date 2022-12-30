import 'package:flutter/material.dart';

Widget humiditySensorStatus({required String humidity}) {
  const Color humidColor = Color(0xff86AB8A);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Image.asset(
            "assets/icons/humidity.png",
          height: 30,
        ),
        Text(
          humidity,
          style: const TextStyle(color: humidColor),
        ),
      ],
    ),
  );
}
