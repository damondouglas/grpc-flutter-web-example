import 'src/generated/calculator.pbgrpc.dart';
import 'src/generated/calculator.pb.dart';

export 'src/generated/calculator.pb.dart';
export 'src/generated/calculator.pbgrpc.dart';

import 'constants.dart';

class Client {
  final String endpoint;
  Client(this.endpoint);
  bool get isMock => this.endpoint == kMockEndpoint;

  Future<double> add(List<double> values) {
    if (this.isMock) {
      print(values);
      return Future.value(null);
    }
    return Future.value(0);
  }
}

