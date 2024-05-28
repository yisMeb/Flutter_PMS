import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Visualizer extends StatefulWidget {
  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  final List<ChartData> chartData = [
    ChartData('Project1', 75, const Color.fromARGB(255, 109, 101, 218)),
    ChartData('Project3', 80, const Color.fromARGB(255, 4, 5, 4)),
    ChartData('Project2', 90, const Color.fromARGB(255, 39, 35, 245)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                cornerStyle: CornerStyle.bothCurve,
                innerRadius: '50%',
                maximumValue: 100,
                gap: '6',
                pointColorMapper: (ChartData data, _) => data.color,
              ),
            ],
            legend: Legend(
                isVisible: true,
                position: LegendPosition.right,
                orientation: LegendItemOrientation.vertical),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
