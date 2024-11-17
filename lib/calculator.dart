import 'package:calculator_app/colors.dart';
import 'package:calculator_app/widget/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String userInput = "";
  String result = "0";

  List<String> buttonsList = [
    "C", "(", ")", "/", 
    "7", "8", "9", "*", 
    "4", "5", "6", "+", 
    "1", "2", "3", "-", 
    "AC", "0", ".", "=",
  ];

  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? darkColor : lightColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    darkMode = !darkMode;
                  });
                },
                child: _switchMode(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Flexible(flex: 3, child: resultWidget()),
              Flexible(flex: 7, child: buttonWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      darkMode: darkMode,
      borderRadius: BorderRadius.circular(40),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.wb_sunny,
              color: darkMode ? Colors.grey : Colors.redAccent,
            ),
            Icon(
              Icons.nightlight_round,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget resultWidget() {
    double fontSizeInput = MediaQuery.of(context).size.width * 0.06;
    double fontSizeResult = MediaQuery.of(context).size.width * 0.1;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          alignment: Alignment.centerRight,
          child: Text(
            userInput,
            style: TextStyle(
              fontSize: fontSizeInput,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Text(
                '=',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  color: darkMode ? Colors.green : Colors.grey,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: TextStyle(
                  fontSize: fontSizeResult,
                  fontWeight: FontWeight.bold,
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonWidget() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.02,
      ),
      itemCount: buttonsList.length,
      itemBuilder: (BuildContext context, int index) {
        return buttons(buttonsList[index]);
      },
    );
  }

  Widget buttons(String text) {
    double buttonSize = MediaQuery.of(context).size.width * 0.18;
    return NeuContainer(
      padding: const EdgeInsets.all(0),
      darkMode: darkMode,
      borderRadius: BorderRadius.circular(40),
      margin: EdgeInsets.all(buttonSize * 0.1),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: MaterialButton(
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              handleButtonPressed(text);
            });
          },
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: getColor(text),
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleButtonPressed(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }

    if (text == "C" && userInput.isNotEmpty) {
      userInput = userInput.substring(0, userInput.length - 1);
      return;
    }

    if (text == "=") {
      result = calculate();
      if (result.endsWith(".0")) result = result.replaceAll(".0", "");
      return;
    }

    userInput += text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "ERROR";
    }
  }

  getColor(String text) {
    if (text == '/' || text == "*" || text == "+" || text == "-" || text == "=" || text == "(" || text == ")") {
      return darkMode ? Colors.green : Colors.redAccent;
    }
    if (text == "C" || text == "AC") {
      return darkMode ? Colors.green : Colors.redAccent;
    }
    return darkMode ? Colors.white : Colors.black;
  }
}
