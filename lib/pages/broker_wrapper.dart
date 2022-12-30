import 'dart:developer';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';

import '../services/providers/BrokerProvider.dart';

class BrokerWrapper extends HookWidget {
  const BrokerWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPressed = useState<bool>(false);
    const backgroundColor = Color(0xFFE7ECEF);

    String buttonMsg = isPressed.value ? "Connecting..." : "Not Connected";

    double blurRadius = isPressed.value ? 5.0 : 30.0;
    Offset offsetDistance =
        isPressed.value ? const Offset(10, 10) : const Offset(-28, -28);

    final brokerHostController = useTextEditingController();

    void onClick() async {
      isPressed.value = !isPressed.value;
      log(brokerHostController.text);
      context.read<BrokerProvider>().setHost(host: brokerHostController.text);
      context.read<BrokerProvider>().initialize();
      context.read<BrokerProvider>().connect();
      await Navigator.of(context).pushReplacementNamed('/home');
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onClick,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: blurRadius,
                            offset: -offsetDistance,
                            color: Colors.white,
                            inset: isPressed.value),
                        BoxShadow(
                            blurRadius: blurRadius,
                            offset: offsetDistance,
                            color: const Color(0xFFA7A9AF),
                            inset: isPressed.value)
                      ]),
                  child: SizedBox(
                    height: 200,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: brokerHostController,
                            autocorrect: false,
                            keyboardType: TextInputType.url,
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(buttonMsg),
                          const Spacer(
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
