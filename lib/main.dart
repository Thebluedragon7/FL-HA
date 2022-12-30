import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/broker_wrapper.dart';
import './pages/homepage.dart';
import './services/providers/BrokerProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BrokerProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const BrokerWrapper(),
          '/home': (context) => const HomePage()
        },
      ),
    ),
  );
}
