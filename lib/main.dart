import 'package:flutter/material.dart';

import 'home_page.dart';
import 'imc_setstate.dart';
import 'imc_stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.cyan, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/imc_setstate': (_) => const ImcSetStatePage(),
          // '/imc_value_notifier': (_) => const ImcValueNotifierPage(),
          // '/imc_change_notifier': (_) => const ImcChangeNotifierPage(),
          '/imc_stream': (_) => const ImcStreamPage(),
        });
  }
}
