// Zipzit original work.  Draw a simple sine wave, add markings to understand 
// Canvas placement.  The canvas thing is pretty bizzare.  As written, the
// canvas centers in the middle of the widget, but you can actually plot negative 
// values without error. Way odd.   There is nothing present that requires you 
// to stay within the canvas element.

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
  static double radPerDegree = 2.0 * pi / 360.0;
  static double degreesPerTic = 8.0;  // 360 mod 8 = 0
  static double amplitudeFactor = 100.0;
  List<Offset> data = [
    new Offset(0.0, amplitudeFactor * sin(0.0 * degreesPerTic * radPerDegree))
  ];

  void changeData() {
    setState(() {
      for (var i = 0; i < 360/degreesPerTic; i++) {
        var nextTic = data[data.length - 1].dx + 1;
        data.add(new Offset(nextTic,
            amplitudeFactor * sin(nextTic * degreesPerTic * radPerDegree)));
      }
      print(data.length);
      if (data.length > 400){
        clearData();
      }
    });
  }

  void clearData() {
    setState(() {
      data = [
        new Offset(
            0.0, amplitudeFactor * sin(0.0 * degreesPerTic * radPerDegree))
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(300.0, 150.0),
          painter: LineChartPainter(data),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: changeData,
        heroTag: null,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  // https://stackoverflow.com/questions/46799285/how-to-draw-line-chart-for-flutter-app
  LineChartPainter(this.data);

  final List<Offset> data;

  @override
  void paint(Canvas canvas, Size size) {
    final paintRed = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final paintBlue = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    canvas.drawPoints(PointMode.polygon, data, paintRed); // PointMode.lines = dotted line, ugh..

    const double dotRadiusSize = 5.0;
    canvas.drawCircle(new Offset(0.0, size.height), dotRadiusSize, paintBlue);
    canvas.drawCircle(new Offset(size.width, size.height), dotRadiusSize, paintBlue); 
    canvas.drawCircle(new Offset(0.0, 0.0), dotRadiusSize, paintBlue);
    canvas.drawCircle(new Offset(size.width, 0.0), dotRadiusSize, paintBlue); 
    canvas.drawCircle(new Offset(0.0, -size.height), dotRadiusSize, paintRed);
    canvas.drawCircle(new Offset(size.width, -size.height), dotRadiusSize, paintRed); 
  }

  @override
  bool shouldRepaint(LineChartPainter old) => data.length != old.data.length;
}
