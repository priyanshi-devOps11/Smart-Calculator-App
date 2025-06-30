import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const SmartCalculator());
}

class SmartCalculator extends StatelessWidget {
  const SmartCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String userInput = '';
  String result = '';
  List<String> history = [];


  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    'sin', 'cos', 'tan', '*',
    'log', '√', '^', '-',
    '7', '8', '9', '+',
    '4', '5', '6', '(',
    '1', '2', '3', ')',
    '0', '.', 'ANS', '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Calculator")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ History List
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(
                          history[index],
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Input + Result
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(userInput, style: const TextStyle(fontSize: 30, color: Colors.white)),
                      const SizedBox(height: 10),
                      Text(result, style: const TextStyle(fontSize: 40, color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOperator(buttons[index]) ? Colors
                        .deepPurple : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () => handleButtonPress(buttons[index]),
                  child: Text(
                      buttons[index], style: const TextStyle(fontSize: 24)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    return ['%', '/', '*', '-', '+', '='].contains(x);
  }

  void handleButtonPress(String btnText) {
    setState(() {
      if (btnText == 'C') {
        userInput = '';
        result = '';
      } else if (btnText == 'DEL') {
        userInput = userInput.isNotEmpty
            ? userInput.substring(0, userInput.length - 1)
            : '';
      } else if (btnText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(
              userInput.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();

          // ✅ Add to history
          history.add('$userInput = $result');
        } catch (e) {
          result = 'Error';
        }
      } else if (btnText == 'ANS') {
        userInput += result;
      } else if (btnText == '√') {
        userInput += 'sqrt(';
      } else if (btnText == 'sin' || btnText == 'cos' || btnText == 'tan' ||
          btnText == 'log') {
        userInput += '$btnText(';
    } else {
        userInput += btnText;
      }
    });
  }
}
