import 'package:calculator/services/calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaml/yaml.dart';
import 'constants.dart';

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
              ChangeNotifierProvider(create: (_) => Console()),
            ],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnswerWindow(),
                  InputConsole(),
                  OperatorButton(
                    width: kFitWidth,
                    operation: Operation.equals,
                  ),
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
    var console = Provider.of<Console>(context);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blueGrey,
        ),
        height: 60.0,
        width: kFitWidth,
        child: Center(
          child: Text(console.buffer,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
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

class Console extends ChangeNotifier {
  final _negatives = RegExp(r'-\d+');
  final _positives = RegExp(r'\+\d+');
  final _beginsWithPlus = RegExp(r'^\+');
  final _endsWithNumber = RegExp(r'\d$');

  final _sb = StringBuffer();
  String get buffer => _sb.toString();

  void write(String value) {
    value = value.trim();
    _sb.write(value);
    notifyListeners();
  }

  void clear() {
    this._sb.clear();
    notifyListeners();
  }

  bool get isEmpty => _sb.isEmpty;
  bool get endsWithNumber => _endsWithNumber.hasMatch(_sb.toString());

  List<double> get values {

    var buffer = _sb.toString();
    if (!_beginsWithPlus.hasMatch(buffer)) {
      buffer = '+' + buffer;
    }

    if (!_endsWithNumber.hasMatch(buffer)) {
      buffer = buffer.substring(0, buffer.length - 1);
    }

    var neg = _negatives.allMatches(buffer)
    .map((source) => source.group(0));

    var pos = _positives.allMatches(buffer)
    .map((source) => source.group(0));

    var collect = List<String>();
    collect.addAll(neg);
    collect.addAll(pos);

    return collect.map((source) => double.parse(source)).toList();
  }
}

class InputConsole extends StatefulWidget {
  @override
  _InputConsoleState createState() => _InputConsoleState();
}

class _InputConsoleState extends State<InputConsole> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight,
      width: kWidth,
      child: Center(
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(20),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: <Widget>[
            NumberButton(
              value: 7,
            ),
            NumberButton(
              value: 8,
            ),
            NumberButton(
              value: 9,
            ),
            NumberButton(
              value: 4,
            ),
            NumberButton(
              value: 5,
            ),
            NumberButton(
              value: 6,
            ),
            NumberButton(
              value: 1,
            ),
            NumberButton(
              value: 2,
            ),
            NumberButton(
              value: 3,
            ),
            NumberButton(
              value: 0,
            ),
            OperatorButton(
              operation: Operation.add,
            ),
            OperatorButton(
              operation: Operation.subtract,
            ),
          ],
        ),
      ),
    );
  }
}

class NumberButton extends StatefulWidget {
  final int value;
  NumberButton({@required this.value});
  @override
  _NumberButtonState createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> {
  @override
  Widget build(BuildContext context) {
    var console = Provider.of<Console>(context);
    return CardButton(
      onTap: () {
        if (widget.value == 0 && console.isEmpty) return;
        console.write('${widget.value}');
      },
      label: '${widget.value}',
    );
  }
}

enum Operation {
  add,
  subtract,
  equals,
}

class OperatorButton extends StatefulWidget {
  final Operation operation;
  final double width;
  OperatorButton({@required this.operation, this.width});
  @override
  _OperatorButtonState createState() => _OperatorButtonState();
}

class _OperatorButtonState extends State<OperatorButton> {
  @override
  Widget build(BuildContext context) {
    var config = Config.of(context);
    var console = Provider.of<Console>(context);
    var label = "";
    switch(widget.operation) {
      case Operation.add:
        label = "+";
        break;
      case Operation.subtract:
        label = "-";
        break;
      case Operation.equals:
        label = "=";
        break;
    }
    return CardButton(
      width: widget.width,
      onTap: () async {
        if (widget.operation == Operation.equals) {
          var client = Client(config.endpoint);
          var answer = await client.add(console.values);
          console.clear();
          if (answer != null) {
            console.write('$answer');
          }
          return;
        }
        if (console.isEmpty) return;
        if (!console.endsWithNumber) return;
        console.write(label);
      },
      label: label,
      color: widget.operation == Operation.equals ? Colors.redAccent : Colors.green,
    );
  }
}


class CardButton extends StatefulWidget {
  final String label;
  final Function onTap;
  final Color color;
  final double width;
  CardButton({@required this.label, this.onTap, this.color, this.width});
  @override
  _CardButtonState createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Ink(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: widget.color != null ? widget.color : Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        width: widget.width,
        child: Center(
          child: Text(widget.label,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
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