import 'package:flutter/material.dart';

import 'imc_change_notifier.dart';
import 'imc_value_notifier.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State Managers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/imc_setstate'),
              child: const Text('imc  - Set State'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const ImcValueNotifierPage())),
              child: const Text('imc  - ValueNotifier'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).push(ImcChangeNotifierPage.route()),
              child: const Text('imc  - ChangeNotifier'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/imc_stream'),
              child: const Text('imc  - Stream'),
            ),
          ],
        ),
      ),
    );
  }
}
