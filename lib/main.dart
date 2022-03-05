/*
Copyright (c) 2022 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/slide_selector.dart';
import 'components/week_summary.dart';
import 'laughing_data.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(const LOLTrackerApp());
}

class LOLTrackerApp extends StatelessWidget {
  const LOLTrackerApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LOLTracker',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        body: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int activeWeek = 3;
  PageController summaryController = PageController(
    viewportFraction: 1,
    initialPage: 3,
  );

  double chartHeight = 160;
  static const leftPadding = 60.0;
  static const rightPadding = 60.0;

  Path _path = Path();
  Path _fillPath = Path();

  late List<ChartDataPoint> prevChartData;
  late List<ChartDataPoint> chartData;

  late AnimationController _pathController;
  CurvedAnimation? _pathCurve;
  Animation? _pathAnimation;

  @override
  void initState() {
    super.initState();
    setState(() {
      chartData = normalizeData(weeksData[activeWeek - 1]);
      prevChartData = normalizeData(zeroStateData);
    });

    _pathController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400), value: 0);
    _pathCurve = CurvedAnimation(
      parent: _pathController,
      curve: Curves.ease,
      reverseCurve: Curves.easeInQuart,
    );
    _pathAnimation = Tween(begin: 0.0, end: 1.0).animate(_pathCurve!)
      ..addListener(() {
        setState(() {
          _path = drawPath(false);
          _fillPath = drawPath(true);
        });
      });

    _pathController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        prevChartData = chartData;
      });
    });
  }

  List<ChartDataPoint> normalizeData(WeekData weekData) {
    final maxDay = weekData.days.reduce((DayData a, DayData b) {
      return a.laughs > b.laughs ? a : b;
    });
    final normalizedList = <ChartDataPoint>[];
    weekData.days.forEach((element) {
      normalizedList.add(ChartDataPoint(
          value: maxDay.laughs == 0 ? 0 : element.laughs / maxDay.laughs));
    });
    return normalizedList;
  }

  Path drawPath(bool closePath) {
    final path = Path();
    final w = MediaQuery.of(context).size.width;
    final h = chartHeight;
    final segmentWidth =
        (1 / (chartData.length - 1) / 3) * (w - leftPadding - rightPadding);

    path.moveTo(0, getY(prevChartData, chartData, 0));

    path.lineTo(leftPadding, getY(prevChartData, chartData, 0));

    // curved line
    for (var i = 1; i < chartData.length; i++) {
      path.cubicTo(
          (3 * (i - 1) + 1) * segmentWidth + leftPadding,
          getY(prevChartData, chartData, i - 1),
          (3 * (i - 1) + 2) * segmentWidth + leftPadding,
          getY(prevChartData, chartData, i),
          (3 * (i - 1) + 3) * segmentWidth + leftPadding,
          getY(prevChartData, chartData, i));
    }

    path.lineTo(w, getY(prevChartData, chartData, chartData.length - 1));

    // for the gradient fill, we want to close the path
    if (closePath) {
      path.lineTo(w, h);
      path.lineTo(0, h);
    }
    return path;
  }

  double getY(
      List<ChartDataPoint> prevData, List<ChartDataPoint> newData, int index) {
    // uses linear interpolation and the animation value to transition from
    // the previous to the new chart point
    final v = _pathAnimation!.value as double;
    return chartHeight -
        ui.lerpDouble(prevData[index].value, newData[index].value, v)! *
            chartHeight;
  }

  void changeWeek(int week) {
    if (!_pathController.isAnimating) {
      setState(() {
        activeWeek = week;
        chartData = normalizeData(weeksData[week - 1]);
        _pathController.value = 0.0;
        _pathController.forward();
        summaryController.animateToPage(week,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          prevChartData = chartData;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DashboardBackground(),
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 60,
              margin: const EdgeInsets.only(top: 60),
              alignment: Alignment.center,
              child: const Text(
                'LOL 😆 Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SlideSelector(
                defaultSelectedIndex: activeWeek - 1,
                tappable: !_pathController.isAnimating,
                items: <SlideSelectorItem>[
                  SlideSelectorItem(
                    text: 'Week 1',
                    onTap: () {
                      changeWeek(1);
                    },
                  ),
                  SlideSelectorItem(
                    text: 'Week 2',
                    onTap: () {
                      changeWeek(2);
                    },
                  ),
                  SlideSelectorItem(
                    text: 'Week 3',
                    onTap: () {
                      changeWeek(3);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: chartHeight + 80,
              color: const Color(0xFF158443),
              child: Stack(
                children: [
                  ChartLaughLabels(
                    chartHeight: chartHeight,
                    topPadding: 40,
                    bottomPadding: 40,
                    leftPadding: leftPadding,
                    rightPadding: rightPadding,
                    weekData: weeksData[activeWeek - 1],
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ChartDayLabels(
                      leftPadding: leftPadding,
                      rightPadding: rightPadding,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    child: CustomPaint(
                      size:
                          Size(MediaQuery.of(context).size.width, chartHeight),
                      painter: PathPainter(path: _path, fillPath: _fillPath),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 400,
              child: PageView.builder(
                clipBehavior: Clip.none,
                physics: const NeverScrollableScrollPhysics(),
                controller: summaryController,
                itemCount: 4,
                itemBuilder: (_, i) {
                  return WeekSummary(week: i);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardBackground extends StatelessWidget {
  const DashboardBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xFF158443),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  Path fillPath;
  PathPainter({required this.path, required this.fillPath});

  @override
  void paint(Canvas canvas, Size size) {
    // double w = size.width;
    final h = size.height;

    // paint the line
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawPath(path, paint);

    // paint the gradient fill
    paint.style = PaintingStyle.fill;
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0.0, h),
      [
        Colors.white.withOpacity(0.2),
        Colors.white.withOpacity(0.85),
      ],
    );
    canvas.drawPath(fillPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ChartDataPoint {
  double value;
  ChartDataPoint({required this.value});
}

class ChartLaughLabels extends StatelessWidget {
  const ChartLaughLabels({
    Key? key,
    required this.chartHeight,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftPadding,
    required this.rightPadding,
    required this.weekData,
  }) : super(key: key);

  final double chartHeight;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;
  final WeekData weekData;

  @override
  Widget build(BuildContext context) {
    const labelCount = 4;
    final maxDay = weekData.days.reduce((DayData a, DayData b) {
      return a.laughs > b.laughs ? a : b;
    });
    final rowHeight = (chartHeight) / labelCount;

    final labels = <double>[];
    for (var i = 0; i < labelCount; i++) {
      labels.add(maxDay.laughs.toDouble() -
          (i * maxDay.laughs.toDouble() / (labelCount - 1)));
    }

    Offset labelOffset(int length, double i) {
      final segment = 1 / (length - 1);
      final offsetValue = (i - ((length - 1) / 2)) * segment;
      return Offset(0, offsetValue);
    }

    return Container(
      height: chartHeight + topPadding + bottomPadding,
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels
            .asMap()
            .entries
            .map(
              (entry) => FractionalTranslation(
                translation: labelOffset(labelCount, entry.key.toDouble()),
                child: Container(
                  height: rowHeight,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftPadding,
                        child: Text(
                          entry.value.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ),
                      SizedBox(width: rightPadding),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ChartDayLabels extends StatelessWidget {
  const ChartDayLabels(
      {Key? key, required this.leftPadding, required this.rightPadding})
      : super(key: key);

  final double leftPadding;
  final double rightPadding;

  Offset labelOffset(int length, double i) {
    final segment = 1 / (length - 1);
    final offsetValue = (i - ((length - 1) / 2)) * segment;
    return Offset(offsetValue, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.85)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .asMap()
              .entries
              .map(
                (entry) => FractionalTranslation(
                  // translation: const Offset(-0.5, 0),
                  translation: labelOffset(7, entry.key.toDouble()),
                  child: SizedBox(
                    width: 36,
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA9A9A9),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
