import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Visualizer extends StatefulWidget {
  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: topPieChart(),
    );
  }

  PieChart topPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        centerSpaceRadius: 5,
        sectionsSpace: 0,
        borderData: FlBorderData(
          show: false,
        ),
        sections: showingSections(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOutCubic,
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 310.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            value: 35,
            title: '35%',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            color: const Color.fromARGB(255, 109, 101, 218),
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            value: 40,
            title: '40%',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            color: const Color.fromARGB(255, 39, 35, 245),
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            value: 55,
            title: '55%',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            color: const Color.fromARGB(255, 4, 5, 4),
            radius: radius,
          );
        case 3:
          return PieChartSectionData(
            value: 100,
            title: '100%\nCategory 1',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            color: const Color.fromARGB(255, 0, 119, 255),
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }
}
