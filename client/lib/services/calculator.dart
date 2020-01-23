import 'package:grpc/grpc_web.dart';

import 'src/generated/calculator.pbgrpc.dart';
import 'src/generated/calculator.pb.dart';

export 'src/generated/calculator.pb.dart';
export 'src/generated/calculator.pbgrpc.dart';

import 'constants.dart';

class Client {
  final String endpoint;
  Client(this.endpoint);
  bool get isMock => this.endpoint == kMockEndpoint;

  Future<double> add(List<double> values) async {
    if (this.isMock) {
      print(values);
      return null;
    }
    final channel = GrpcWebClientChannel.xhr(Uri.parse(this.endpoint));
    final client = CalculatorClient(channel);
    final request = Input();
    request.values.addAll(values);
    final answer = await client.add(request);
    return answer.value;
  }
}

