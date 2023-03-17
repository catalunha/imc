import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'imc_gauge.dart';

class ImcChangeNotifierController extends ChangeNotifier {
  double imc = 0;
  Future<void> calcularImc(
      {required double peso, required double altura}) async {
    imc = 0;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    imc = peso / (altura * altura);
    notifyListeners();
  }
}

class ImcChangeNotifierPage extends StatefulWidget {
  const ImcChangeNotifierPage({super.key});

  @override
  State<ImcChangeNotifierPage> createState() => _ImcChangeNotifierPageState();
}

class _ImcChangeNotifierPageState extends State<ImcChangeNotifierPage> {
  final formKey = GlobalKey<FormState>();
  final pesoTEC = TextEditingController();
  final alturaTEC = TextEditingController();
  final imcController = ImcChangeNotifierController();
  var formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);

  @override
  void dispose() {
    pesoTEC.dispose();
    alturaTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC para InfoEng - ChangeNotifier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: imcController,
                  builder: (context, child) {
                    return ImcGauge(
                      imc: imcController.imc,
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: imcController,
                  builder: (context, child) {
                    return Text('IMC = ${formatter.format(imcController.imc)}');
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: pesoTEC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      turnOffGrouping: true,
                      decimalDigits: 2,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso obrigatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: alturaTEC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      turnOffGrouping: true,
                      decimalDigits: 2,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura obrigatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      var formValid = formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        double peso = formatter.parse(pesoTEC.text) as double;
                        double altura =
                            formatter.parse(alturaTEC.text) as double;
                        imcController.calcularImc(peso: peso, altura: altura);
                      }
                    },
                    child: const Text('Calcular IMC'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
