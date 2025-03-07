import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isDarkMode = true;
  String text = '0';
  String history = '';
  double numOne = 0;
  double numTwo = 0;
  String result = '';
  String finalResult = '0';
  String opr = '';
  String preOpr = '';

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor,
      {double fontSize = 30}) {
    return ElevatedButton(
      onPressed: () => calculation(btntxt),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          btntxt,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: txtcolor),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: EdgeInsets.all(0),
        backgroundColor: btncolor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDarkMode ? Color.fromRGBO(23, 23, 28, 1) : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          history,
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black54,
                              fontSize: 24),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          text,
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 80),
                        ),
                      ),
                    ),
                    buttonRow([
                      'C',
                      '+/-',
                      '%',
                      '÷'
                    ], [
                      Colors.grey,
                      Colors.grey,
                      Colors.grey,
                      Color(0xFF4B5EFC)
                    ], [
                      30,
                      15,
                      30,
                      30
                    ]),
                    buttonRow(
                      ['7', '8', '9', 'x'],
                      [
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Color(0xFF4B5EFC)!
                      ],
                    ),
                    buttonRow(
                      ['4', '5', '6', '-'],
                      [
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Color(0xFF4B5EFC)!
                      ],
                    ),
                    buttonRow(
                      ['1', '2', '3', '+'],
                      [
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Color(0xFF4B5EFC)!
                      ],
                    ),
                    buttonRow(
                      ['.', '0', '⌫', '='],
                      [
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Colors.grey[850]!,
                        Color(0xFF4B5EFC)!
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: SizedBox(
                width: 35,
                height: 35,
                child: FloatingActionButton(
                  backgroundColor:
                      isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  child: Icon(
                    isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: isDarkMode ? Colors.yellow : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonRow(List<String> labels, List<Color> colors,
      [List<double>? fontSizes]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          labels.length,
          (index) => SizedBox(
            width: 80,
            height: 80,
            child: calcButton(labels[index], colors[index], Colors.white,
                fontSize: fontSizes?[index] ?? 30),
          ),
        ),
      ),
    );
  }

  void calculation(String btnText) {
    if (btnText == 'C') {
      text = '0';
      history = '';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
    } else if (btnText == '⌫') {
      if (result.isNotEmpty) {
        result = result.substring(0, result.length - 1);
        finalResult = result.isNotEmpty ? result : '0';
      }
    } else if (btnText == '+/-') {
      result = result.startsWith('-') ? result.substring(1) : '-' + result;
      finalResult = result;
    } else if (['+', '-', 'x', '÷', '='].contains(btnText)) {
      if (numOne == 0) {
        numOne = double.tryParse(result) ?? 0;
      } else {
        numTwo = double.tryParse(result) ?? 0;
      }
      performOperation(opr);
      preOpr = opr;
      opr = btnText;
      result = '';
      history += btnText;
    } else if (btnText == '%') {
      result = (numOne / 100).toString();
      finalResult = formatNumber(result);
    } else {
      result += btnText;
      finalResult = formatNumber(result);
      history += btnText;
    }
    setState(() {
      text = finalResult;
    });
  }

  void performOperation(String operation) {
    if (operation == '+') {
      numOne += numTwo;
    } else if (operation == '-') {
      numOne -= numTwo;
    } else if (operation == 'x') {
      numOne *= numTwo;
    } else if (operation == '÷') {
      numOne = numTwo != 0 ? numOne / numTwo : 0;
    }
    finalResult = numOne.toString();
    result = '';
    numTwo = 0;
  }

  String formatNumber(String num) {
    if (num.contains('.') && num.split('.')[1] == '0') {
      return num.split('.')[0]; // Remove o ".0"
    }
    return num;
  }
}
