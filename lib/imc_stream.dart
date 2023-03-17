import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'imc_gauge.dart';

class ImcState {
  double imc;
  ImcState({
    required this.imc,
  });
}

class ImcStreamController {
  final _imcState = StreamController<ImcState>.broadcast()
    ..add(ImcState(imc: 0));
  Stream<ImcState> get imcOut => _imcState.stream;
  void close() {
    _imcState.close();
  }

  Future<void> calcularImc(
      {required double peso, required double altura}) async {
    _imcState.add(ImcState(imc: 0));
    await Future.delayed(const Duration(seconds: 1));
    double imc = peso / (altura * altura);
    _imcState.add(ImcState(imc: imc));
  }
}

class ImcStreamPage extends StatefulWidget {
  const ImcStreamPage({super.key});

  @override
  State<ImcStreamPage> createState() => _ImcStreamPageState();
}

class _ImcStreamPageState extends State<ImcStreamPage> {
  final imcController = ImcStreamController();

  final formKey = GlobalKey<FormState>();
  final pesoTEC = TextEditingController();
  final alturaTEC = TextEditingController();
  var formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);

  @override
  void dispose() {
    pesoTEC.dispose();
    alturaTEC.dispose();
    imcController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC - Stream'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                StreamBuilder<ImcState>(
                  stream: imcController.imcOut,
                  builder: (context, snapshot) {
                    return ImcGauge(
                      imc: snapshot.data?.imc ?? 0,
                    );
                  },
                ),
                StreamBuilder<ImcState>(
                  stream: imcController.imcOut,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          'IMC = ${formatter.format(snapshot.data?.imc ?? 0)}');
                    }
                    return Container();
                  },
                ),
                // const SizedBox(height: 20),
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
