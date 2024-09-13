import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/utility/utility.dart';

class EventGraph extends StatefulWidget {
  const EventGraph({super.key});

  @override
  State<EventGraph> createState() => _EventGraphState();
}

class _EventGraphState extends State<EventGraph> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                DateTime now = DateTime.now();
                String month = Utility.getMonthName(now.month);
                String year = now.year.toString();
                switch (value.toInt()) {
                  case 0:
                    return Padding(
                      padding: const EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '01 $month, $year',
                        style: const TextStyle(
                          color: Color(0xff97abc1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  case 29:
                    return Padding(
                      padding: const EdgeInsets.only(right: 70, top: 20),
                      child: Text(
                        '30 $month, $year',
                        style: const TextStyle(
                          color: Color(0xff97abc1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(),
        maxY: 4,
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return [
      for (int i = 0; i < 30; i++)
        _makeGroupData(
          i,
          allEvents
              .where((event) {
                DateTime now = DateTime.now();
                DateTime eventDate = dateFormat.parse(event.date);
                return eventDate.day == i + 1 && eventDate.month == now.month;
              })
              .length
              .toDouble(),
        )
    ];
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xff99aaff),
          borderRadius: BorderRadius.circular(0),
          width: 10,
        ),
      ],
    );
  }
}
