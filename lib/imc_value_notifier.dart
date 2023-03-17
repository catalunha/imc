import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'imc_gauge.dart';

class ImcValueNotifierPage extends StatefulWidget {
  const ImcValueNotifierPage({super.key});

  @override
  State<ImcValueNotifierPage> createState() => _ImcValueNotifierPageState();
}

class _ImcValueNotifierPageState extends State<ImcValueNotifierPage> {
  final formKey = GlobalKey<FormState>();
  final pesoTEC = TextEditingController();
  final alturaTEC = TextEditingController();
  var imc = ValueNotifier<double>(0.0);
  var formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
  Future<void> _calcularImc(
      {required double peso, required double altura}) async {
    imc.value = 0;
    await Future.delayed(const Duration(seconds: 1));
    imc.value = peso / (altura * altura);
  }

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
        title: const Text('IMC - ValueNotifier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: imc,
                  builder: (_, value, __) {
                    return ImcGauge(
                      imc: value,
                    );
                  },
                ),
                ValueListenableBuilder<double>(
                  valueListenable: imc,
                  builder: (_, value, __) {
                    return Text('IMC = ${formatter.format(value)}');
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
                        _calcularImc(peso: peso, altura: altura);
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
