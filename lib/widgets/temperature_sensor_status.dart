import 'package:flutter/material.dart';

Widget buildTemperatureMeter({required String temperature}) {
  const Color tempColor = Colors.red;
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        const Icon(
          Icons.thermostat,
          color: tempColor,
        ),
        Text(
          temperature,
          style: const TextStyle(color: tempColor),
        ),
      ],
    ),
  );
}
// ℃