import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaml/yaml.dart';

final kThemeData = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF0A0E21),
);

final kConfigPath = 'assets/config.yaml';
final kEndpointKey = 'endpoint';
final kMockEndpoint = 'mock';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kThemeData,
      home: Scaffold(
        body: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(kConfigPath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        var doc = loadYaml(snapshot.data);

        return Config(
          endpoint: doc[kEndpointKey],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Answer()),
            ],
            child: Center(
              child: Column(
                children: <Widget>[
                  AnswerWindow(),
                ],
              ),
            ),
          ),
        );
      },
    );

  }
}

class AnswerWindow extends StatefulWidget {
  @override
  _AnswerWindowState createState() => _AnswerWindowState();
}

class _AnswerWindowState extends State<AnswerWindow> {
  @override
  Widget build(BuildContext context) {
    var config = Config.of(context);
    return Center(
      child: Text('hi'),
    );
  }
}

class Answer extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  void set(double value) {
    _value = value;
    notifyListeners();
  }
}

class Config extends InheritedWidget {
  final String endpoint;
  final Widget child;
  Config({@required this.endpoint, this.child});

  static Config of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Config>();
  }

  bool get isMock => this.endpoint == kMockEndpoint;

  @override
  bool updateShouldNotify(Config old) => endpoint != old.endpoint;
}