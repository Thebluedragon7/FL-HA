import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../services/providers/BrokerProvider.dart';

class LightToggleButton extends HookWidget {
  final ValueNotifier<bool> status;
  final BrokerProvider provider;

  const LightToggleButton(
      {Key? key, required this.status, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double blurRadius = status.value ? 5.0 : 30.0;
    Offset offsetDistance =
        status.value ? const Offset(10, 10) : const Offset(-20, -20);

    return GestureDetector(
      onTap: () {
        provider.switchLight();
        status.value = !status.value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(150),
          boxShadow: [
            BoxShadow(
                blurRadius: blurRadius,
                offset: -offsetDistance,
                color: const Color(0xffffffff),
                inset: status.value),
            BoxShadow(
                blurRadius: blurRadius,
                offset: offsetDistance,
                color: const Color(0xffbabec1),
                inset: status.value),
          ],
        ),
        child: const SizedBox(
          height: 100,
          width: 100,
          child: Icon(
            Icons.lightbulb,
            size: 33,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
