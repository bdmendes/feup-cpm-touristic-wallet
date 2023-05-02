import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/amounts_provider.dart';
import '../../provider/exchange_rates_provider.dart';
import 'label_indicator.dart';

class StatisticsPieChart extends StatefulWidget {
  const StatisticsPieChart({super.key});

  @override
  State<StatefulWidget> createState() => StatisticsPieChartState();
}

class StatisticsPieChartState extends State {
  int touchedIndex = -1;
  var colors = <String, int>{};

  @override
  Widget build(BuildContext context) {
    return Consumer2<AmountsProvider, ExchangeRatesProvider>(
      builder: (context, amountsProvider, exchangeRatesProvider, child) {
        return FutureBuilder(
          future: amountsProvider.getExchangeAmounts(exchangeRatesProvider),
          builder:  (context, snapshot) {
            if (snapshot.hasData) {
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
                        sectionsSpace: 0,
                        centerSpaceRadius: 50,
                        sections: showingSections(snapshot.data!),
                      ),
                    ),
                  ),
                  Wrap(
                      spacing: 12.0, // gap between adjacent chips
                      runSpacing: 8.0, // gap between lines
                      direction: Axis.horizontal,
                      children: showingIndicators(amountsProvider,exchangeRatesProvider)
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          }
        );
      }
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> exchangeAmounts) {
    return List.generate(exchangeAmounts.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 30.0 : 20.0;
      final radius = isTouched ? 130.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      var key = exchangeAmounts.keys.toList()[i];
      var total = exchangeAmounts.values.reduce((a, b) => a + b);
      if (!colors.containsKey(key)) {
        colors[key] = Random().nextInt(0xffffffff);
      }
      return PieChartSectionData(
        color: Color(colors[key]!).withAlpha(0xff),
        value: exchangeAmounts[key],
        title: exchangeAmounts[key]! / total < 0.03 ? "" : exchangeAmounts[key]!.toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  List<LabelIndicator> showingIndicators(
      AmountsProvider amountsProvider, ExchangeRatesProvider exchangeRatesProvider) {
    return List.generate(amountsProvider.amounts.length, (i) {
      return LabelIndicator(
        color: Color(colors[amountsProvider.amounts[i].currency]!).withAlpha(0xff),
        text: amountsProvider.amounts[i].currency,
        isSquare: false,
      );
    });
  }
}
