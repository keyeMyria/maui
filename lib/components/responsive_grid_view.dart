import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int cols;
  final int rows;
  final EdgeInsetsGeometry padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  ResponsiveGridView(
      {@required this.children,
      @required this.cols,
      @required this.rows,
      this.padding = const EdgeInsets.all(4.0),
      this.mainAxisSpacing = 4.0,
      this.crossAxisSpacing = 4.0,
      this.childAspectRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    print('ResponsiveGridView.build');
    return new LayoutBuilder(builder: (context, constraints) {
      print(constraints);
      List<Widget> tableRows = new List<Widget>();
      for (var i = 0; i < rows; ++i) {
        List<Widget> cells = children
            .skip(i * cols)
            .take(cols)
            .map((w) => new Expanded(
                child: new Padding(padding: padding,
                    child: new AspectRatio(
                    aspectRatio: constraints.maxWidth *
                        rows /
                        (constraints.maxHeight * 0.90 * cols),
                    child: w))))
            .toList(growable: false);
        tableRows.add(new Row(children: cells));
      }

      return new Padding(
        padding: const EdgeInsets.all(4.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: tableRows,
      ));
    });
  }
}
