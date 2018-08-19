// Zipzit original work.  Draw a simple sine wave, add markings to understand 
// Canvas placement.  

// use canvas.drawLine() within a for loop one segment at a time in lieu of the 
// easy canvas.drawPoints().
// remember we want to capture test data in a simple list, and window the display
// arround that appropriately.  There do not appear to exist any libraries that
// do that today. We can just do it the hard way, one pixel at a time wiithin 
// canvas.  

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
  static double degreesPerTic = 8.0; // 360 mod 8 = 0
  static double amplitudeFactor = 100.0;
  static double randomAmplitude = 50.0;
  static var rng = new Random();
  List<Offset> data = [
    new Offset(
        0.0,
        (amplitudeFactor * sin(0.0 * degreesPerTic * radPerDegree)) +
            (randomAmplitude * rng.nextDouble()))
  ];

  void changeData() {
    setState(() {
      for (var i = 0; i < 360 / degreesPerTic; i++) {
        var nextTic = data[data.length - 1].dx + 1;
        data.add(new Offset(
            nextTic,
            amplitudeFactor * sin(nextTic * degreesPerTic * radPerDegree)   +
                randomAmplitude * rng.nextDouble() ) );
      }
      print(data.length);
      if (data.length > 400) {
        clearData();
      }
    });
  }

  void clearData() {
    setState(() {
      data = [
        new Offset(
            0.0,
            (amplitudeFactor * sin(0.0 * degreesPerTic * radPerDegree)) +
                (randomAmplitude * rng.nextDouble()))
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(300.0, 250.0),
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
      ..strokeWidth = 1.0;

    final paintBlue = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    canvas.drawPoints(PointMode.polygon, data,
        paintRed); // PointMode.lines = dotted line, ugh..

    int startTic = 100;
    int endTic = 250;
    double vertOffset = 225.0;
    int tempLength = data.length;
    print("data length: $tempLength");

    if ((data.length > startTic) && (data.length > endTic)) {
      for (var i = startTic; i < endTic - 1; i++) {
        canvas.drawLine(
            new Offset(data[i].dx - startTic, data[i].dy + vertOffset),
            new Offset(data[i + 1].dx - startTic, data[i + 1].dy + vertOffset),
            paintBlue);
      }
    }
    if ((data.length > startTic) && (data.length < endTic)) {
      for (var i = startTic; i < data.length - 1; i++) {
        canvas.drawLine(
            new Offset(data[i].dx - startTic, data[i].dy + vertOffset),
            new Offset(data[i + 1].dx - startTic, data[i + 1].dy + vertOffset),
            paintBlue);
      }
    }

    const double dotRadiusSize = 5.0;
    canvas.drawCircle(new Offset(0.0, size.height), dotRadiusSize, paintBlue);
    canvas.drawCircle(
        new Offset(size.width, size.height), dotRadiusSize, paintBlue);
    canvas.drawCircle(new Offset(0.0, 0.0), dotRadiusSize, paintBlue);
    canvas.drawCircle(new Offset(size.width, 0.0), dotRadiusSize, paintBlue);
    canvas.drawCircle(new Offset(0.0, -size.height), dotRadiusSize, paintRed);
    canvas.drawCircle(
        new Offset(size.width, -size.height), dotRadiusSize, paintRed);
  }

  @override
  bool shouldRepaint(LineChartPainter old) => data.length != old.data.length;
}
