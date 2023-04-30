import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class StatisticsPieChart extends StatefulWidget {
  const StatisticsPieChart({super.key});

  @override
  State<StatefulWidget> createState() => StatisticsPieChartState();
}

class StatisticsPieChartState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Expanded(
            child: PieChart(
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
                      touchedIndex = pieTouchResponse
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 5,
                centerSpaceRadius: 50,
                sections: showingSections(),
              ),
            ),
          ),
          const Wrap(
            spacing: 12.0, // gap between adjacent chips
            runSpacing: 8.0, // gap between lines
            direction: Axis.horizontal,
            children: <Widget>[
              Indicator(
                color: Color(0xFF2196F3),
                text: 'First',
                isSquare: false,
              ),
              Indicator(
                color: Color(0xFFFFC300),
                text: 'Second',
                isSquare: false,
              ),
              Indicator(
                color: Color(0xFF6E1BFF),
                text: 'Third',
                isSquare: false,
              ),
              Indicator(
                color: Color(0xFF3BFF49),
                text: 'Fourth',
                isSquare: false,
              )
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      );
    //);
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 30.0 : 20.0;
      final radius = isTouched ? 130.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFF2196F3),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFFFFC300),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xFF6E1BFF),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFF3BFF49),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
