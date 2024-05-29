import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';

class Visualizer extends StatefulWidget {
  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      final List<Map<String, dynamic>> projects =
          await DatabaseServices().fetchProjects();
      projects.sort((a, b) {
        final DateTime endDateA = DateTime.parse(a['endDate']);
        final DateTime endDateB = DateTime.parse(b['endDate']);
        return endDateA.compareTo(endDateB);
      });
      final int numberOfProjects = projects.length > 3 ? 3 : projects.length;
      chartData = List.generate(numberOfProjects, (index) {
        final String projectName = projects[index]['title'];
        final double progress = _calculateProgress(
            DateTime.parse(projects[index]['startDate']),
            DateTime.parse(projects[index]['endDate']));
        final Color? color = _getColorBasedOnProgress(progress);
        return ChartData(projectName, progress, color);
      });
      setState(() {});
    } catch (error) {
      print('Error fetching projects: $error');
    }
  }

  double _calculateProgress(DateTime startDate, DateTime endDate) {
    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = DateTime.now().difference(startDate).inDays;
    return (elapsedDuration / totalDuration * 100).clamp(0.0, 100.0);
  }

  Color? _getColorBasedOnProgress(double progress) {
    const Color startColor = Color.fromARGB(255, 72, 255, 118);
    const Color endColor = Color.fromARGB(255, 80, 78, 78);
    if (progress == 0.0) {
      return Colors.yellow;
    } else if (progress == 100.0) {
      return const Color.fromARGB(179, 255, 30, 0);
    } else if (progress < 50.0) {
      return const Color.fromARGB(228, 33, 149, 243);
    } else if (progress > 87) {
      return Colors.orange;
    }
    return Color.lerp(startColor, endColor, progress / 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
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
              orientation: LegendItemOrientation.vertical,
            ),
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
  final Color? color;
}
