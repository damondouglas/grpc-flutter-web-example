import 'package:grpc/grpc.dart';

import 'calculator.dart';

class MockCalculator extends CalculatorServiceBase {
  @override
  Future<Answer> add(ServiceCall call, Input input) async {
    return Answer()..value = 0.0;
  }

  @override
  Future<Answer> subtract(ServiceCall call, Input input) async {
    return Answer()..value = 0.0;
  }
}