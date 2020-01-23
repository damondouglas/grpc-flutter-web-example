///
//  Generated code. Do not modify.
//  source: calculator.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'calculator.pb.dart' as $0;
export 'calculator.pb.dart';

class CalculatorClient extends $grpc.Client {
  static final _$add = $grpc.ClientMethod<$0.Input, $0.Answer>(
      '/calculatorpb.Calculator/Add',
      ($0.Input value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Answer.fromBuffer(value));

  CalculatorClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Answer> add($0.Input request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$add, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class CalculatorServiceBase extends $grpc.Service {
  $core.String get $name => 'calculatorpb.Calculator';

  CalculatorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Input, $0.Answer>(
        'Add',
        add_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Input.fromBuffer(value),
        ($0.Answer value) => value.writeToBuffer()));
  }

  $async.Future<$0.Answer> add_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Input> request) async {
    return add(call, await request);
  }

  $async.Future<$0.Answer> add($grpc.ServiceCall call, $0.Input request);
}
