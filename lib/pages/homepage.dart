import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

import '../services/providers/BrokerProvider.dart';
import '../widgets/humidity_sensor_status.dart';
import '../widgets/temperature_sensor_status.dart';
import '../widgets/toggle_light_button.dart';
import '../widgets/toggle_pump_button.dart';
import '../widgets/water_tank_status.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return () {
        context.read<BrokerProvider>().disconnect();
      };
    }, []);

    final provider = Provider.of<BrokerProvider>(context);
    final isLightOn = useState<bool>(false);
    final isPumpOn = useState<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Automation"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: provider.startListening(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final MqttReceivedMessage message = snapshot.data![0];
              if (message.payload is MqttPublishMessage) {
                final MqttPublishMessage publishMessage = message.payload;
                final String pt = MqttPublishPayload.bytesToStringAsString(
                    publishMessage.payload.message);
                final topic = message.topic;
                if (topic == "sys/temperature") {
                  provider.setTemperature("$pt℃");
                } else if (topic == "sys/humidity") {
                  provider.setHumidity("$pt%");
                } else if (topic == "sys/tank") {
                  provider.setTank(pt);
                } else if (topic == "room/light") {
                  if (pt == "on") {
                    isLightOn.value = true;
                  } else {
                    isLightOn.value = false;
                  }
                } else if (topic == "sys/pump") {
                  if (pt == "on") {
                    isPumpOn.value = true;
                  } else {
                    isPumpOn.value = false;
                  }
                } else {
                  log("$topic: $pt");
                }
              } else {
                // The message is not an MqttPublishMessage
              }
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Tooltip(
                        message: "Temperature Status",
                        child: buildTemperatureMeter(
                            temperature: provider.temperature),
                      ),
                      const Spacer(),
                      Tooltip(
                        message: "Humidity Status",
                        child:
                            humiditySensorStatus(humidity: provider.humidity),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: Tooltip(
                      message: "Water Tank Status",
                      child: buildWaterTankMeter(waterLevel: provider.tank),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                LightToggleButton(provider: provider, status: isLightOn),
                const Spacer(flex: 3),
                PumpToggleButton(provider: provider, status: isPumpOn),
                const Spacer(flex: 3),
              ],
            );
          },
        ),
      ),
    );
  }
}
