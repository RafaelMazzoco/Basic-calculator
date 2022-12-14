import 'package:calculator/design_system/calculation_history.dart';
import 'package:calculator/design_system/calculator_button.dart';
import 'package:calculator/design_system/result_display.dart';
import 'package:calculator/feature/model/calculation_model.dart';
import 'package:calculator/presenter/calculation/bloc/calculation_bloc.dart';
import 'package:calculator/presenter/calculation/bloc/calculation_event.dart';
import 'package:calculator/presenter/calculation/bloc/calculation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Calculation extends StatefulWidget {
  const Calculation({Key? key}) : super(key: key);

  static const routName = '/calculation';

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  late double width;

  @override
  void initState() {
    context.read<CalculationBloc>().add(FetchHistory());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculationBloc, CalculationState>(
        builder: (context, CalculationState state) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 28,
            ),
            ResultDisplay(
              text: _getDisplayText(state.calculationModel),
            ),
            Row(
              children: [
                _getButton(text: '7', onTap: () => numberPressed(7)),
                _getButton(text: '8', onTap: () => numberPressed(8)),
                _getButton(text: '9', onTap: () => numberPressed(9)),
                _getButton(
                    text: 'X',
                    onTap: () => operatorPressed('*'),
                    backgroundColor: const Color.fromRGBO(220, 220, 220, 1)),
              ],
            ),
            Row(
              children: [
                _getButton(text: '4', onTap: () => numberPressed(4)),
                _getButton(text: '5', onTap: () => numberPressed(5)),
                _getButton(text: '6', onTap: () => numberPressed(6)),
                _getButton(
                    text: '/',
                    onTap: () => operatorPressed('/'),
                    backgroundColor: const Color.fromRGBO(220, 220, 220, 1)),
              ],
            ),
            Row(
              children: [
                _getButton(text: '1', onTap: () => numberPressed(1)),
                _getButton(text: '2', onTap: () => numberPressed(2)),
                _getButton(text: '3', onTap: () => numberPressed(3)),
                _getButton(
                    text: '+',
                    onTap: () => operatorPressed('+'),
                    backgroundColor: const Color.fromRGBO(220, 220, 220, 1)),
              ],
            ),
            Row(
              children: [
                _getButton(
                    text: '=',
                    onTap: calculateResult,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white),
                _getButton(text: '0', onTap: () => numberPressed(0)),
                _getButton(
                    text: 'C',
                    onTap: clear,
                    backgroundColor: const Color.fromRGBO(220, 220, 220, 1)),
                _getButton(
                    text: '-',
                    onTap: () => operatorPressed('-'),
                    backgroundColor: const Color.fromRGBO(220, 220, 220, 1)),
              ],
            ),
            const Spacer(),
            CalculationHistoryContainer(
              calculations: state.history.reversed.toList(),
            ),
          ],
        ),
      );
    });
  }

  _getButton({
    required String text,
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return CalculatorButton(
      label: text,
      onTap: onTap,
      size: 90,
      backgroundColor: backgroundColor,
      labelColor: textColor,
    );
  }

  String _getDisplayText(CalculationModel model) {
    if (model.result != null) {
      return '${model.result}';
    }

    if (model.secondOperand != null) {
      return '${model.firstOperand}${model.operator}${model.secondOperand}';
    }

    if (model.operator != null) {
      return '${model.firstOperand}${model.operator}';
    }

    if (model.firstOperand != null) {
      return '${model.firstOperand}';
    }

    return '${model.result ?? 0}';
  }

  void numberPressed(int number) {
    context.read<CalculationBloc>().add(NumberPressed(number: number));
  }

  void operatorPressed(String operator) {
    context.read<CalculationBloc>().add(OperatorPressed(operator: operator));
  }

  void calculateResult() {
    context.read<CalculationBloc>().add(CalculateResult());
  }

  void clear() {
    context.read<CalculationBloc>().add(ClearCalculation());
  }
}
