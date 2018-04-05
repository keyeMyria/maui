import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';

class CalculateTheNumbers extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  CalculateTheNumbers(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _CalculateTheNumbersState();
}

class _CalculateTheNumbersState extends State<CalculateTheNumbers>
    with SingleTickerProviderStateMixin {
  final List<String> _allNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '✖',
    '0',
    '✔'
  ];

  final int _size = 3;
  List<String> _numbers;
  String _preValue = ' ';
  int num1,
      num2,
      num1digit1,
      num1digit2,
      num1digit3,
      num2digit1,
      num2digit2,
      num2digit3;
  int result;
  String _output = ' ';
  String _operator = '';
  bool flag;
  Animation animation;
  AnimationController animationController;
  Tuple4<int, String, int, int> data;
  bool _isLoading = true;
  String options;
  List<num> reminder = [];

  @override
  void initState() {
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 20.0).animate(animationController);
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _numbers = _allNumbers.sublist(0, _size * (_size + 1));
    data = await fetchMathData(widget.gameCategoryId);
    print(data);
    num1 = data.item1;
    num2 = data.item3;
    result = data.item4;
    _operator = data.item2;
    setState(() => _isLoading = false);
    if (num1 % 10 == num1 && num2 % 10 == num2) {
      options = 'one';
    } else if (calCount(num1) == 2 || calCount(num2) == 2) {
      options = 'doubleDigitWithoutCarry';
      num1digit2 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit1 = num1 % 10;
      num2digit2 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit1 = num2 % 10;
    } else if (calCount(num1) == 3 || calCount(num2) == 3) {
      options = 'tripleDigitWithoutCarry';
      num1digit3 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit2 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit1 = num1 % 10;
      num2digit3 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit2 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit1 = num2 % 10;
    } else {
      options = 'one';
    }
  }

  void reminderS(sum) {
    while (sum != 0) {
      num rem = sum % 10;
      sum = sum ~/ 10;
      reminder.add(rem);
    }
  }

  int calCount(sum) {
    print(sum);
    int count = 0;
    if (sum > 1) {
      while (sum != 0) {
        sum = sum ~/ 10;
        ++count;
      }
      return count;
    } else {
      return count = 1;
    }
  }

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
    // print(oldWidget.iteration);
    //  print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  void _myAnim() {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
    print('Pushed the Button');
  }

  void wrongOrRight(String text, String output, sum) {
    if (text == '✔') {
      try {
        if (int.parse(output) == result) {
          setState(() {
            _output = output;
          });
          widget.onScore(1);
          widget.onProgress(1.0);
          if (int.parse(output) == sum) {
            new Future.delayed(const Duration(milliseconds: 1000), () {
              _output = ' ';
              flag = false;
              widget.onEnd();
            });
          }
        } else {
          _myAnim();
          print("Entering wrong data");
          new Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _output = " ";
              flag = false;
            });
            animationController.stop();
          });
        }
      } on FormatException {}
    }
    if (text == '✖') {
      print("Erasing content: " + output);
      if (_output.length > 0) {
        try {
          setState(() {
            _output = _output.substring(0, _output.length - 1);
            flag = false;
          });
        } on FormatException {}
      }
    }
  }

  bool _zeoToNine(String text) {
    if (text == '1' ||
        text == '2' ||
        text == '3' ||
        text == '4' ||
        text == '5' ||
        text == '6' ||
        text == '7' ||
        text == '8' ||
        text == '9' ||
        text == '0') {
      return true;
    } else
      return false;
  }

  void operation(String text) {
    if (_zeoToNine(text) == true) {
      if (_output.length < 3) {
        _preValue = text;
        _output = _output + _preValue;
        print(_output);
        setState(() {
          if (int.parse(_output) == result) {
            _output;
            flag = true;
            print("OUTPUT: " + _output);
          }
        });
      } else {
        setState(() {
          flag = false;
        });
      }
    }
    wrongOrRight(text, _output, result);
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          operation(text);
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _displayContainer(String text, Color color, Key key) {
    return new Expanded(
      child: new FittedBox(
        child: new Container(
          height: 30.0,
          width: 30.0,
          color: color,
          child: new Center(
            child: new Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    switch (options) {
      case 'one':
        return new LayoutBuilder(builder: (context, constraints) {
          var j = 0;
          return new Column(
            children: <Widget>[
               new Expanded(
                 child: new Container(
                   color: Colors.white,
                  child: new Column(
                     children: <Widget>[
                       new Expanded(
                         child: new Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             _displayContainer(" ", Colors.white, new Key(" ")),
                             _displayContainer(" ", Colors.white, new Key(" ")),
                             _displayContainer(
                                 '$num1', Colors.limeAccent, new Key("num1")),
                             _displayContainer(" ", Colors.white, new Key(" ")),
                         ],
                         ),
                       ),
                       new Padding(
                         padding: const EdgeInsets.all(2.0),
                       ),
                       new Expanded(
                         child: new Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             _displayContainer(" ", Colors.white, new Key(" ")),
                       _displayContainer(_operator, Colors.limeAccent,
                                 new Key("_operator")),
                             _displayContainer(
                                 '$num2', Colors.limeAccent, new Key("num2")),
                             _displayContainer(" ", Colors.white, new Key(" ")),
                           ],
                         ),
                       ),
                       new Padding(
                         padding: const EdgeInsets.all(2.0),
                      ),
                   new Expanded(
                         child: new Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             _displayContainer(" ", Colors.white, new Key(" ")),
                             _displayContainer(" ", Colors.white, new Key(" ")),
                             _displayContainer(
                                 _output,
                                flag == true ? Colors.green : Colors.redAccent,
                               new Key("_optput")),
                           _displayContainer(" ", Colors.white, new Key(" ")),
                           ],
                       ),
                       ),
                     ],
                 ),
                ),
              ),
              /* new Expanded(
                child: new Table(
                  children: <TableRow>[
                    new TableRow(children: <Widget>[
                      new Center(
                        child: new Container(
                           height: 300.0,
                           width: 300.0,
                          color: Colors.red,
                          child: new Center(
                            child: new Text(" "),
                          ),
                        ),
                      ),
                      /* new Container(
                            height: 30.0, width: 30.0, child: new Text(" ")), */
                      new Center(
                        child: new Container(
                            height: 300.0,
                            width: 300.0,
                            color: Colors.teal,
                            child: new Center(child: new Text("$num1"))),
                      ),
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(
                          height: 300.0,
                          width: 300.0,
                          color: Colors.teal,
                          child: new Center(child: new Text(_operator))),
                      new Container(
                          height: 300.0,
                          width: 300.0,
                          color: Colors.teal,
                          child: new Center(child: new Text("$num2"))),
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(
                          height: 300.0,
                          width: 300.0,
                          child: new Center(child: new Text(" "))),
                      new Container(
                          height: 300.0,
                          width: 300.0,
                          color: Colors.teal,
                          child: new Center(child: new Text(_output))),
                    ]),
                  ],
                ),
              ), */
              new Expanded(
                child: new Container(
                  color: Colors.white,
                  child: new ResponsiveGridView(
                    rows: _size + 1,
                    cols: _size,
                    childAspectRatio: 0.6,
                    children: _numbers
                        .map((e) => _buildItem(j++, e))
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
          );
        });
        break;

      case 'doubleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          var j = 0;
          return new Column(
            children: <Widget>[
              new Expanded(
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        child: new Row(
                          children: <Widget>[
                            _displayContainer(" ", Colors.white, new Key(" ")),
                            _displayContainer("$num1digit1 ", Colors.limeAccent,
                                new Key(" ")),
                            _displayContainer('$num1digit2', Colors.limeAccent,
                                new Key("num1")),
                            _displayContainer(" ", Colors.white, new Key(" ")),
                          ],
                        ),
                      ),
                      new Expanded(
                        child: new Row(
                          children: <Widget>[
                            _displayContainer(
                                _operator, Colors.limeAccent, new Key(" ")),
                            _displayContainer('$num2digit1', Colors.limeAccent,
                                new Key("num1")),
                            _displayContainer("$num2digit2 ", Colors.limeAccent,
                                new Key(" ")),
                            _displayContainer(" ", Colors.white, new Key(" ")),
                          ],
                        ),
                      ),
                      new Expanded(
                        child: new Row(
                          children: <Widget>[
                            _displayContainer(
                                _output, Colors.redAccent, new Key(" ")),
                            _displayContainer(
                                _output, Colors.redAccent, new Key("num1")),
                            _displayContainer(
                                _output, Colors.redAccent, new Key(" ")),
                            _displayContainer(" ", Colors.white, new Key(" ")),
                            // _displayContainer(" ", Colors.white, new Key(" ")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Expanded(
                  child: new Container(
                color: Colors.white,
                child: new ResponsiveGridView(
                  rows: _size + 1,
                  cols: _size,
                  childAspectRatio: 0.7,
                  children: _numbers
                      .map((e) => _buildItem(j++, e))
                      .toList(growable: false),
                ),
              )),
            ],
          );
        });
        break;
      default:
        return new Container();
        /*   List<TableRow> rows;
   //    List<Widget> cells=_displayContainer("hii", Colors.red, new Key(''));
        rows.add(new TableRow(children:_displayContainer("hii", Colors.red, new Key('g'))));
        return new Table(children: rows); */
        break;
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);
  final String text;
  bool flag;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;
    //  print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        // print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          //  print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text.isEmpty && widget.text.isNotEmpty) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    // print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(
        scale: animation,
        child: new RaisedButton(
            onPressed: () => widget.onPress(),
            color: Colors.pinkAccent,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
            child: new Center(
              child: new Text(_displayText,
                  style: new TextStyle(color: Colors.black, fontSize: 25.0)),
            )));
  }
}

class TextAnimation extends AnimatedWidget {
  TextAnimation({Key key, Animation animation, this.text, this.flag})
      : super(key: key, listenable: animation);
  final String text;
  final bool flag;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return new Container(
        height: 50.0,
        width: 50.0,
        alignment: Alignment.center,
        margin: new EdgeInsets.only(right: animation.value ?? 0, bottom: 10.0),
        child: new Text(text,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            )),
        color: flag == true ? Colors.green : Colors.grey);
  }
}

class DisplayCon {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      height: 30.0,
      width: 30.0,
      child: new Text("hiii"),
    ));
  }
}
