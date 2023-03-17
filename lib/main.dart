import 'package:flutter/material.dart';

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
      home: const ImcStreamPage(),
    );
  }
}
