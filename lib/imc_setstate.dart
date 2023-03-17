import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'imc_gauge.dart';

class ImcSetState extends StatefulWidget {
  const ImcSetState({super.key, required this.title});

  final String title;

  @override
  State<ImcSetState> createState() => _ImcSetStateState();
}

class _ImcSetStateState extends State<ImcSetState> {
  final formKey = GlobalKey<FormState>();
  final pesoTEC = TextEditingController();
  final alturaTEC = TextEditingController();
  double imc = 35;
  var formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
  void _calcularImc({required double peso, required double altura}) async {
    setState(() {
      imc = 0;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      imc = peso / (altura * altura);
    });
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
        title: const Text('IMC para InfoEng - set state'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ImcGauge(
                  imc: imc,
                ),
                Text('IMC = ${formatter.format(imc)}'),
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
