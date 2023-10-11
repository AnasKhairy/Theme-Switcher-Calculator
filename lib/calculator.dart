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
    "C",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "AC",
    "0",
    ".",
    "=",
  ];

  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? darkColor : lightColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      darkMode ? darkMode = false : darkMode = true;
                    });
                  },
                  child: _switchMode()),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                flex: 2,
                child: resultWidget(),
              ),
              Flexible(
                flex: 5,
                child: buttonWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        margin: const EdgeInsets.all(5),
        child: SizedBox(
          width: 70,
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
        ));
  }

  Widget resultWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            userInput,
            style: TextStyle(
              fontSize: 25,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                '=',
                style: TextStyle(
                  fontSize: 35,
                  color: darkMode ? Colors.green : Colors.grey,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: TextStyle(
                  fontSize: 55,
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: buttonsList.length,
      itemBuilder: (BuildContext context, int index) {
        return buttons(buttonsList[index]);
      },
    );
  }

  Widget buttons(String text, {double padding = 20}) {
    return NeuContainer(
        padding: const EdgeInsets.all(0),
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        margin: EdgeInsets.all(padding / 2),
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
              width: padding * 2,
              height: padding * 2,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: getColor(text),
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  handleButtonPressed(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }

    if (text == "C" && userInput != '') {
      userInput = userInput.substring(0, userInput.length - 1);
      return;
    }

    if (text == "=") {
      result = calculate();
      if (result.endsWith(".0")) result = result.replaceAll(".0", "");
      return;
    }

    userInput = userInput + text;
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
    if (text == '/' ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "=" ||
        text == "(" ||
        text == ")") {
      return darkMode ? Colors.green : Colors.redAccent;
    }
    if (text == "C" || text == "AC") {
      return darkMode ? Colors.green : Colors.redAccent;
    }
    return darkMode ? Colors.white : Colors.black;
  }
}
