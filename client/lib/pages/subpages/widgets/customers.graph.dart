import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/utility/utility.dart';

class CustomersGraph extends StatefulWidget {
  const CustomersGraph({super.key, required this.date});
  final int date;

  @override
  State<CustomersGraph> createState() => _CustomersGraphState();
}

class _CustomersGraphState extends State<CustomersGraph> {
  List<LineChartBarData> getLineBarsDataForDate0() {
    return [
      LineChartBarData(
        spots: const [
          FlSpot(1, 0),
          FlSpot(4, 0),
          FlSpot(7, 0),
          FlSpot(10, 0),
          FlSpot(13, 0),
          FlSpot(16, 0),
          FlSpot(19, 100),
          FlSpot(22, 0),
          FlSpot(25, 10),
          FlSpot(28, 21),
        ],
        isCurved: false,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0xffebeeff),
        ),
        color: const Color(0xff6d85ff),
        dotData: const FlDotData(show: false),
      ),
      LineChartBarData(
        spots: const [
          FlSpot(1, 0),
          FlSpot(4, 0),
          FlSpot(7, 0),
          FlSpot(10, 0),
          FlSpot(13, 32),
          FlSpot(16, 58),
          FlSpot(19, 38),
          FlSpot(22, 52),
          FlSpot(25, 70),
          FlSpot(28, 73),
        ],
        isCurved: false,
        isStrokeCapRound: true,
        barWidth: 2,
        color: const Color(0xffbac9ff),
        dashArray: [5, 5],
        dotData: const FlDotData(show: false),
      ),
    ];
  }

  List<LineChartBarData> getLineBarsDataForDate2() {
    return [
      LineChartBarData(
        spots: const [
          FlSpot(1, 15),
          FlSpot(10, 25),
          FlSpot(20, 30),
          FlSpot(25, 40),
          FlSpot(30, 50),
          FlSpot(35, 60),
          FlSpot(40, 70),
        ],
        isCurved: false,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0xffebeeff),
        ),
        color: const Color(0xff6d85ff),
        dotData: const FlDotData(show: false),
      ),
      LineChartBarData(
        spots: const [
          FlSpot(1, 20),
          FlSpot(10, 35),
          FlSpot(20, 50),
          FlSpot(25, 58),
          FlSpot(30, 65),
          FlSpot(35, 73),
          FlSpot(40, 80),
        ],
        isCurved: false,
        isStrokeCapRound: true,
        barWidth: 2,
        color: const Color(0xffbac9ff),
        dashArray: [5, 5],
        dotData: const FlDotData(show: false),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int date = widget.date;
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 14,
              getTitlesWidget: (value, meta) {
                DateTime now = DateTime.now();
                String month = Utility.getMonthName(now.month);
                String year = now.year.toString();

                switch (date) {
                  case 1:
                    switch (value.toInt()) {
                      case 1:
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
                      case 14:
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            '15 $month, $year',
                            style: const TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      case 30:
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
                    }
                    break;

                  case 0:
                    switch (value.toInt()) {
                      case 1:
                        return const Padding(
                          padding: EdgeInsets.only(left: 70, top: 20),
                          child: Text(
                            'Monday',
                            style: TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      case 14:
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Thursday',
                            style: TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      case 30:
                        return const Padding(
                          padding: EdgeInsets.only(right: 70, top: 20),
                          child: Text(
                            'Sunday',
                            style: TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                    }
                    break;
                  case 2:
                    DateTime lastMonth = DateTime(now.year, now.month - 1);
                    DateTime twoMonthsAgo = DateTime(now.year, now.month - 2);
                    String currentMonth = Utility.getMonthName(now.month);
                    String previousMonth =
                        Utility.getMonthName(lastMonth.month);
                    String twoMonthsBefore =
                        Utility.getMonthName(twoMonthsAgo.month);
                    switch (value.toInt()) {
                      case 1:
                        return Padding(
                          padding: const EdgeInsets.only(left: 70, top: 20),
                          child: Text(
                            twoMonthsBefore,
                            style: const TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      case 14:
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            previousMonth,
                            style: const TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      case 30:
                        return Padding(
                          padding: const EdgeInsets.only(right: 70, top: 20),
                          child: Text(
                            currentMonth,
                            style: const TextStyle(
                              color: Color(0xff97abc1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                    }
                    break;
                }

                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              interval: allCustomers.length.toDouble(),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Color(0xff97abc1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
        ),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          if (date == 2)
            ...getLineBarsDataForDate0()
          else if (date == 0)
            ...getLineBarsDataForDate2()
          else ...[
            LineChartBarData(
              spots: [
                const FlSpot(1, 10),
                const FlSpot(3, 20),
                const FlSpot(5, 15),
                const FlSpot(7, 30),
                const FlSpot(9, 25),
                const FlSpot(11, 40),
                const FlSpot(13, 35),
                const FlSpot(15, 50),
                const FlSpot(17, 45),
                const FlSpot(19, 60),
                const FlSpot(21, 50),
                const FlSpot(23, 70),
                const FlSpot(25, 65),
                const FlSpot(27, 80),
                const FlSpot(29, 70),
                const FlSpot(30, 100),
              ],
              isCurved: false,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xffebeeff),
              ),
              color: const Color(0xff6d85ff),
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: const [
                FlSpot(1, 9),
                FlSpot(3, 25),
                FlSpot(5, 20),
                FlSpot(7, 35),
                FlSpot(9, 15),
                FlSpot(11, 50),
                FlSpot(13, 32),
                FlSpot(15, 58),
                FlSpot(17, 38),
                FlSpot(19, 52),
                FlSpot(21, 48),
                FlSpot(23, 62),
                FlSpot(25, 70),
                FlSpot(27, 73),
                FlSpot(29, 60),
                FlSpot(30, 90),
              ],
              isCurved: false,
              isStrokeCapRound: true,
              barWidth: 2,
              color: const Color(0xffbac9ff),
              dashArray: [5, 5],
              dotData: const FlDotData(show: false),
            ),
          ]
        ],
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
