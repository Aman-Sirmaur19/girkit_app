import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WavelengthGraph extends StatelessWidget {
  final List<FlSpot> spots;
  final String title;
  final Color lineColor;
  final double minY;
  final double maxY;

  const WavelengthGraph({
    super.key,
    required this.spots,
    required this.title,
    required this.lineColor,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250, // Graph height
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Ensure all months are shown
                        getTitlesWidget: (value, meta) {
                          final months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          int index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(
                              months[index],
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20, // Show vertical axis at intervals of 20
                        getTitlesWidget: (value, meta) {
                          if (value >= 400 && value <= 600) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 2),
                      bottom: BorderSide(width: 2),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                    ),
                  ],
                  minX: 0,
                  maxX: 11,
                  // Total months (index 0-11 for Jan-Dec)
                  minY: minY,
                  maxY: maxY, // Wavelength range
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
