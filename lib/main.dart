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

class _DashboardState extends State<Dashboard> {
  int activeWeek = 3;
  PageController summaryController = PageController(
    viewportFraction: 1,
    initialPage: 3,
  );

  void changeWeek(int week) {
    setState(() {
      activeWeek = week;
      summaryController.animateToPage(week,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
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
                'LOL ???? Tracker',
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
            Container(
              height: 300,
              color: const Color(0xFF59DAAB),
              child: const Placeholder(),
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
            color: const Color(0xFF59DAAB),
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
