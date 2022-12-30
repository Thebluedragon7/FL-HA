import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class BrokerProvider with ChangeNotifier {
  String _host = "";
  final int _port = 1883;
  late MqttClient _client;
  final String _identifier = "android";

  // States
  String _brokerStatus = "disconnected";
  bool _isPumpOn = false;
  bool _isLightOn = false;
  String _temperature = "N/A";
  String _humidity = "N/A";
  String _tank = "N/A";

  // Topics
  final String _temperatureSensorTopic = "sys/temperature";
  final String _humiditySensorTopic = "sys/humidity";
  final String _roomLightStatusTopic = "room/light";
  final String _waterPumpStatusTopic = "sys/pump";
  final String _waterLevelStatusTopic = "sys/tank";

  // Getters
  String get brokerStatus => _brokerStatus;
  bool get isPumpOn => _isPumpOn;
  bool get isLightOn => _isLightOn;
  String get temperature => _temperature;
  String get humidity => _humidity;
  String get tank => _tank;

  // Setters
  void setHost({required String host}) {
    _host = host;
  }

  void setTemperature(String temperature) {
    _temperature = temperature;
    notifyListeners();
  }

  void setHumidity(String humidity) {
    _humidity = humidity;
    notifyListeners();
  }

  void setTank(String tank) {
    _tank = tank;
    notifyListeners();
  }

  void initialize() {
    _client = MqttServerClient(_host, _identifier);
    _client.port = _port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: true);

    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('sys/conn')
        .withWillMessage("1")
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    if (kDebugMode) {
      print("FLUTTER::Mosquitto Client Connecting...");
    }

    _client.connectionMessage = connectMessage;

    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onDisconnected = _onDisconnected;
  }

  void connect() async {
    try {
      if (kDebugMode) {
        print("[+] Connecting...");
      }
      await _client.connect();
    } on Exception catch (e) {
      if (kDebugMode) {
        print("[X] Exception: $e");
      }
      disconnect();
    }
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? startListening() =>
      _client.updates;

  void disconnect() {
    if (kDebugMode) {
      print("[+] Disconnecting...");
    }
    _client.disconnect();
  }

  void _onConnected() {
    log("[+] Connected to MQTT broker");
    _client.subscribe(_temperatureSensorTopic, MqttQos.atLeastOnce);
    _client.subscribe(_humiditySensorTopic, MqttQos.atLeastOnce);
    _client.subscribe(_roomLightStatusTopic, MqttQos.atLeastOnce);
    _client.subscribe(_waterPumpStatusTopic, MqttQos.atLeastOnce);
    _client.subscribe(_waterLevelStatusTopic, MqttQos.atLeastOnce);

    _brokerStatus = "connected";
    notifyListeners();
  }

  void _onSubscribed(String topic) {
    log("[+] Subscribed to $topic");
  }

  void _onDisconnected() {
    log("[+] Disconnected");
    _brokerStatus = "disconnected";
    notifyListeners();
  }

  void switchLight() {
    _isLightOn = !_isLightOn;
    publishLight(isOn: _isLightOn);
    notifyListeners();
  }

  void switchWaterPump() {
    _isPumpOn = !_isPumpOn;
    publishWaterPump(isOn: _isPumpOn);
    notifyListeners();
  }

  void publishLight({required bool isOn}) {
    final lightPayloadBuilder = MqttClientPayloadBuilder();
    String data = "off";
    if (isOn) {
      data = "on";
    }
    lightPayloadBuilder.addString(data);
    _client.publishMessage(_roomLightStatusTopic, MqttQos.atMostOnce,
        lightPayloadBuilder.payload!);
  }

  void publishWaterPump({required bool isOn}) {
    final pumpPayloadBuilder = MqttClientPayloadBuilder();
    String data = "off";
    if (isOn) {
      data = "on";
    }
    pumpPayloadBuilder.addString(data);
    _client.publishMessage(
        _waterPumpStatusTopic, MqttQos.atMostOnce, pumpPayloadBuilder.payload!);
  }
}
