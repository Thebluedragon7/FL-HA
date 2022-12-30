import 'package:flutter/material.dart';

Widget buildWaterTankMeter({required String waterLevel}) {
  Color ctxColor = Colors.white;
  return Row(
    children: [
      const Spacer(flex: 6),
      Icon(
        Icons.water_drop_outlined,
        color: ctxColor,
      ),
      const Spacer(flex: 1),
      Text(
        waterLevel,
        style: TextStyle(color: ctxColor, fontSize: 20),
      ),
      const Spacer(flex: 6),
    ],
  );
}
