// Zipzit original work.  Draw a simple sine wave.

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
  static double degreesPerTic = 7.0;
  static double amplitudeFactor = 100.0;
  List<Offset> data = [
    new Offset(0.0, amplitudeFactor * sin(0.0 * degreesPerTic * radPerDegree))
  ];

  void changeData() {
    setState(() {
      for (var i = 0; i < 10; i++) {
        var nextDegree = data[data.length - 1].dx + 1;
        data.add(new Offset(nextDegree,
            amplitudeFactor * sin(nextDegree * degreesPerTic * radPerDegree)));
      }
      print(data.length);
      if (data.length > 300){
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
          size: Size(200.0, 100.0),
          painter: LineChartPainter(data),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.refresh),
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
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;
    canvas.drawPoints(PointMode.polygon, data, paint);  // PointMode.lines = dotted line, ugh..
  }

  @override
  bool shouldRepaint(LineChartPainter old) => data.length != old.data.length;
}
