import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

String test = '';

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  IdentifyGame({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _IdentifyGameState();
}

class _IdentifyGameState extends State<IdentifyGame> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new DropTarget(new Offset(0.0, 0.0)),
        new DragBox(new Offset(38.0, 500.0) ,'face', Colors.red),
        new DragBox(new Offset(126.0, 500.0) ,'cap', Colors.orange),
        new DragBox(new Offset(214.0, 500.0) ,'hand', Colors.lightBlue),
        new DragBox(new Offset(303.0, 500.0) ,'body', Colors.green),
      ],
    );
     // return new Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: <Widget>[
    //     new Padding(
    //       padding: new EdgeInsets.only(top: 30.0),
    //     ),
    //     // new Expanded(
    //     //   flex: 1,
    //     //   child: new Padding(
    //     //     padding: new EdgeInsets.only(top: 5.0)
    //     //   ),
    //     // ),
    //     new Expanded(
    //       flex: 3,
    //       child: new DropTarget(),
    //       // child: new Row(
    //       // mainAxisAlignment: MainAxisAlignment.center,
    //       // children: <Widget>[
    //       //   new Expanded(
    //       //     flex:1,
    //       //     child: new DropTarget(),
    //       //   ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child:  new DropTarget('hand', Colors.red),
    //       //   // ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child: new DropTarget('head', Colors.orange),
    //       //   // ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child: new DropTarget('body', Colors.green),
    //       //   // )
    //       //   // new DropTarget('leg', Colors.lightBlue),
    //       //   // new DropTarget('hand', Colors.red),
    //       //   // new DropTarget('head', Colors.orange),
    //       //   // new DropTarget('body', Colors.green),
    //       //   ],
    //       // ),
    //     ),
    //     new Expanded(
    //       flex: 1,
    //       child: new Row(
    //         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('face', Colors.red),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('cap', Colors.orange),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('hand', Colors.lightBlue),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('body', Colors.green),
    //           ),
    //           // new DragBox('a', Colors.red),
    //           // new DragBox('b', Colors.orange),
    //           // new DragBox('c', Colors.lightBlue),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}

class DropTarget extends StatefulWidget {
  final Offset intipos;
  // final String expectedLabel;
  // final Color dropColor;

  // DropTarget(this.expectedLabel, this.dropColor);
  DropTarget(this.intipos);

  @override
  DropTargetState createState() => new DropTargetState();
}

class DropTargetState extends State<DropTarget> {
  Offset positon = new Offset(0.0, 0.0);
  // String caughtText = '';
  // String expectedText = '';
  // Color targetColor = Colors.cyan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    positon = widget.intipos;
    // expectedText = widget.expectedLabel;
    // targetColor = widget.dropColor;
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: positon.dx,
      right: positon.dy,
      child: new Image(
        image:new AssetImage('assets/Boy.png'),
        height: 420.0,
        width: 249.0,
      ),
      // child: new Container(
      //   decoration: new BoxDecoration(
      //     image: new DecorationImage(
      //       image: new AssetImage('assets/Boy.png'),
      //       fit: BoxFit.contain,
      //     ),
      //   ),
      // ),
    );
    // return new DragTarget(
    //   // onAccept: (String text) {
    //   //   if (text == expectedText) {
    //   //     caughtText = text;
    //   //     test = caughtText;
    //   //   } else {
    //   //     caughtText = '';
    //   //     test = '';
    //   //   }
    //   // },
    //   builder: (
    //     BuildContext context,
    //     List<dynamic> accepted,
    //     List<dynamic> rejected,
    //   ) {
    //     return new Container(
    //       decoration: new BoxDecoration(
    //         image: new DecorationImage(
    //           image: new AssetImage('assets/Boy.png'),
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     );
    //     // return new Container(
    //     //   width: 120.0,
    //     //   height: 120.0,
    //     //   decoration: new BoxDecoration(
    //     //     // color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
    //     //     color: targetColor,
    //     //   ),
    //     //   child: new Center(
    //     //     child: new Text(
    //     //       accepted.isEmpty ? caughtText : '',
    //     //     ),
    //     //   ),
    //     // );
    //   },
    // );
  }
}

class DragBox extends StatefulWidget {
  final Offset intipos;
  final String label;
  final Color itemColor;

  DragBox(this.intipos, this.label, this.itemColor);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> with SingleTickerProviderStateMixin {
  Offset positon = new Offset(0.0, 0.0);
  AnimationController controller;
  Animation<double> animation;

  Color draggableColor;
  String draggableText;

  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = new AnimationController(
        duration: const Duration(milliseconds: 10), vsync: this);
    animation = new Tween(begin: 3.0, end: 8.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    positon = widget.intipos;
    draggableColor = widget.itemColor;
    draggableText = widget.label;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: positon.dx,
      top: positon.dy,
      child: new Draggable(
          data: draggableText,
          child: new AnimatedDrag(
              animation: animation,
              draggableColor: draggableColor,
              draggableText: draggableText),
          feedback: new AnimatedFeedback(
              animation: animation,
              draggableColor: draggableColor,
              draggableText: draggableText),
          onDraggableCanceled: (velocity,offset) {
            if (test == draggableText) {
              controller.stop();
            } else if (test == '') {
              toAnimateFunction();
              new Future.delayed(const Duration(milliseconds: 1000), () {
                controller.stop();
              });
            }
            // setState(() {
            //   positon = offset;
            // });
          }),
    );
  }
}

class AnimatedFeedback extends AnimatedWidget {
  AnimatedFeedback(
      {Key key,
      Animation<double> animation,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      width: 70.0,
      height: 70.0,
      color: draggableColor.withOpacity(0.5),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}

class AnimatedDrag extends AnimatedWidget {
  AnimatedDrag(
      {Key key,
      Animation<double> animation,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      width: 50.0,
      height: 50.0,
      color: draggableColor,
      // margin: new EdgeInsets.only(
      //     left: animation.value ?? 0, right: animation.value ?? 0),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
