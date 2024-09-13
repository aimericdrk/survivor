import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/encounter.module.dart';

class PieChartSample extends StatelessWidget {
  const PieChartSample({super.key});

  Widget legend(String provider, int count, Color color, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            sw(3),
            Text(
              provider,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff8fa4bd),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            sw(5),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff8fa4bd),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double calculatePercentage(int counter, int total) {
    if (total == 0) return 0;
    return (counter / total) * 100;
  }

  List<Map<String, Object>> encountersSummary() {
    Map<String, int> sourceCount = {};

    for (EncounterModel encounter in allEncounters) {
      String source = encounter.source;
      if (sourceCount.containsKey(source)) {
        sourceCount[source] = sourceCount[source]! + 1;
      } else {
        sourceCount[source] = 1;
      }
    }

    List<Map<String, Object>> result = sourceCount.entries.map((entry) {
      return {'name': entry.key as Object, 'counter': entry.value as Object};
    }).toList();

    result.sort((a, b) => (b['counter'] as int).compareTo(a['counter'] as int));

    List<Map<String, Object>> top3 = result.take(3).toList();

    int otherCounter =
        result.skip(3).fold(0, (sum, item) => sum + (item['counter'] as int));

    top3.add({'name': 'Other', 'counter': otherCounter as Object});

    return top3;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> summary = encountersSummary();
    int totalCounter = encountersSummary()
        .fold(0, (sum, item) => sum + (item['counter'] as int));
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 150,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 30,
            sections: _buildSections(
              encountersSummary().map((e) => e['counter'] as int).toList(),
            ),
          ),
        ),
      ),
      sh(30),
      SizedBox(
        width: dw(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legend(
                  encountersSummary()[0]['name'] as String,
                  encountersSummary()[0]['counter'] as int,
                  const Color(0xff748bff),
                  calculatePercentage(
                          summary[0]['counter'] as int, totalCounter)
                      .toInt(),
                ),
                sw(20),
                legend(
                  encountersSummary()[1]['name'] as String,
                  encountersSummary()[1]['counter'] as int,
                  const Color(0xffbbabff),
                  calculatePercentage(
                          summary[1]['counter'] as int, totalCounter)
                      .toInt(),
                ),
              ],
            ),
            sh(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legend(
                  encountersSummary()[2]['name'] as String,
                  encountersSummary()[2]['counter'] as int,
                  const Color(0xffffa4cf),
                  calculatePercentage(
                          summary[2]['counter'] as int, totalCounter)
                      .toInt(),
                ),
                sw(20),
                legend(
                  encountersSummary()[3]['name'] as String,
                  encountersSummary()[3]['counter'] as int,
                  const Color(0xffffda69),
                  calculatePercentage(
                          summary[3]['counter'] as int, totalCounter)
                      .toInt(),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }

  List<PieChartSectionData> _buildSections(List<int> values) {
    return [
      PieChartSectionData(
        color: const Color(0xff748bff),
        value: values[0].toDouble(),
        radius: 60,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xffbbabff),
        value: values[1].toDouble(),
        radius: 60,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xffffa4cf),
        value: values[2].toDouble(),
        radius: 60,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xffffda69),
        value: values[3].toDouble(),
        radius: 60,
        showTitle: false,
      ),
    ];
  }
}
