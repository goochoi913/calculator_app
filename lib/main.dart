// Name: Goo Choi
// Panther ID: 002754498
// Homework #1 - Simple Calculator App
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E222D),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = "0"; 
  String _expressionPreview = ""; 
  double _firstOperand = 0;
  String _operator = "";
  bool _shouldClearDisplay = false; 
  String _percentPreview = "";

  // --- LOGIC METHOD ---
  void _buttonPressed(String buttonText) {
    // reset the state before processing the next button press
    if ((_displayText == "Cannot divide by 0" || _displayText == "Error" || _displayText == "Incomplete") && buttonText != 'C') {
      _displayText = "0";
      _expressionPreview = "";
      _firstOperand = 0;
      _operator = "";
      _shouldClearDisplay = false;
      _percentPreview = "";
    }
    
    setState(() {
      if (buttonText == 'C') {
        // reset all state variables when c was hit
        _displayText = "0";
        _expressionPreview = "";
        _firstOperand = 0;
        _operator = "";
        _shouldClearDisplay = false;
        _percentPreview = "";

      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_operator.isNotEmpty && _shouldClearDisplay) {
          _operator = buttonText;
          _percentPreview = "";
          _expressionPreview = "";
          return;
        }

        _firstOperand = double.parse(_displayText);
        _operator = buttonText;
        _expressionPreview = "";
        _percentPreview = "";
        _shouldClearDisplay = true;
        
      } else if (buttonText == '=') {
        if (_operator.isNotEmpty) {
          // ERROR HANDLING: Catch incomplete expressions (e.g., typing '5', '+', '=')
          if (_shouldClearDisplay) {
            _displayText = "Incomplete";
            _expressionPreview = "";
            _operator = ""; 
            return; 
          }

          double secondOperand = double.parse(_displayText);
          double result = 0;

          if (_operator == '+') result = _firstOperand + secondOperand;
          if (_operator == '-') result = _firstOperand - secondOperand;
          if (_operator == '×') result = _firstOperand * secondOperand;
          if (_operator == '÷') {
            if (secondOperand == 0) {
              _displayText = "Cannot divide by 0";
              _operator = ""; 
              _shouldClearDisplay = true;
              return; // Stop calculating and exit
            }
            result = _firstOperand / secondOperand; 
          }

          // update preview to show the full completed equation before showing result
          String firstOpStr = _firstOperand.toString().replaceAll(RegExp(r'\.0$'), '');
          String secondOpStr = secondOperand.toString().replaceAll(RegExp(r'\.0$'), '');
          
          // use the stored percent string if it exists, otherwise use the standard second operand
          String finalSecondOpStr = _percentPreview.isNotEmpty ? _percentPreview : secondOpStr;
          _expressionPreview = "$firstOpStr $_operator $finalSecondOpStr";

          // format the result to remove trailing '.0' (e.g., show "5" instead of "5.0")
          _displayText = result.toString().replaceAll(RegExp(r'\.0$'), '');
          
          _operator = ""; // reset operator after calculation
          _shouldClearDisplay = true; 
          _percentPreview = ""; // clear it for the next calculation
        }
        
      } else if (buttonText == '±') {
        _percentPreview = "";
        
        if (_shouldClearDisplay) {
          // if starting a new number after an operator, start with negative zero
          _displayText = "-0";
          _shouldClearDisplay = false;
        } else if (_displayText == "0") {
          _displayText = "-0";
        } else if (_displayText.startsWith('-')) {
          _displayText = _displayText.substring(1);
          if (_displayText.isEmpty) _displayText = "0"; // failsafe
        } else {
          _displayText = '-' + _displayText;
        }
        
      } else if (buttonText == '%') {
        if (_shouldClearDisplay && _operator.isNotEmpty) {
          _displayText = "Incomplete";
          _expressionPreview = "";
          _operator = "";
          return;
        }

        // capture the original typed number with a % sign before we do the math
        _percentPreview = "$_displayText%";

        double currentValue = double.parse(_displayText);
        
        if (_operator == '+' || _operator == '-') {
          currentValue = (_firstOperand * currentValue) / 100;
        } else {
          currentValue = currentValue / 100;
        }
        
        _displayText = currentValue.toString().replaceAll(RegExp(r'\.0$'), '');

      } else {
        _percentPreview = ""; 
        
        if (_shouldClearDisplay) {
          if (_operator.isEmpty) {
            _expressionPreview = "";
          }
          
          if (buttonText == ".") {
            _displayText = "0.";
          } else {
            _displayText = buttonText;
          }
          _shouldClearDisplay = false;
        } else {
          // handle replacing "0" or our new "-0" state properly
          if (_displayText == "0" && buttonText != ".") {
            _displayText = buttonText;
          } else if (_displayText == "-0" && buttonText != ".") {
            _displayText = "-" + buttonText;
          } else {
            // this prevent adding multiple decimals in one number
            if (buttonText == "." && _displayText.contains(".")) return;
            _displayText += buttonText;
          }
        }
      }
    });
  }

  // This is a helper method to build buttons
  // This keeps our code DRY (Don't Repeat Yourself)
  Widget _buildButton(String text, {bool isWide = false}) {
    bool isPurpleButton = ['C', '±', '%', '÷', '×', '-', '+', '='].contains(text);
    Color bgColor = isPurpleButton ? const Color(0xFF7163E5) : const Color(0xFF333847);
    
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _buttonPressed(text),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // green text logic
    String currentExpression = _displayText;
    if (_operator.isNotEmpty) {
      String firstOpStr = _firstOperand.toString().replaceAll(RegExp(r'\.0$'), '');
      if (_shouldClearDisplay) {
        currentExpression = "$firstOpStr $_operator";
      } else {
        String displaySecondNumber = _percentPreview.isNotEmpty ? _percentPreview : _displayText;
        currentExpression = "$firstOpStr $_operator $displaySecondNumber";
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // display area
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161922),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // gray preview text
                      Text(
                        _expressionPreview,
                        style: const TextStyle(
                          color: Colors.grey, 
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8), 
                      // main display text
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          currentExpression,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF6EDD8C),
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // button grid area
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(child: Row(children: [_buildButton('C'), _buildButton('±'), _buildButton('%'), _buildButton('÷')])),
                    Expanded(child: Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('×')])),
                    Expanded(child: Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-')])),
                    Expanded(child: Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+')])),
                    Expanded(child: Row(children: [
                      _buildButton('0', isWide: true),
                      _buildButton('.'), 
                      _buildButton('=')
                    ])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}