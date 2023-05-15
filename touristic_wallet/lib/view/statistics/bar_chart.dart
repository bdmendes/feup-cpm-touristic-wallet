import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/amounts_provider.dart';
import '../../provider/exchange_rates_provider.dart';

class StatisticsBarChart extends StatefulWidget {
  const StatisticsBarChart({super.key});

  @override
  State<StatefulWidget> createState() => StatisticsBarChartState();
}

class StatisticsBarChartState extends State<StatisticsBarChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AmountsProvider, ExchangeRatesProvider>(
        builder: (context, amountsProvider, exchangeRatesProvider, child) {
      return AspectRatio(
          aspectRatio: 1.6,
          child: _BarChart(amountsProvider, exchangeRatesProvider));
    });
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart(this.amountsProvider, this.exchangeRatesProvider);

  final AmountsProvider amountsProvider;
  final ExchangeRatesProvider exchangeRatesProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center();
            }
            return BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: getBarGroups(snapshot.data!),
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: snapshot.data!.values.reduce(max) * 1.2,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: amountsProvider.getExchangeAmounts(exchangeRatesProvider));
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: amountsProvider.amounts[groupIndex].color,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: amountsProvider.amounts[value.toInt()].color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        '${amountsProvider.amounts[value.toInt()].value}\n${amountsProvider.amounts[value.toInt()].currency}',
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
            axisNameSize: 30,
            axisNameWidget: Text(
              amountsProvider.currency,
              style: const TextStyle(
                color: Color(0xFF555555),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient getBarsGradient(index) {
    return LinearGradient(
      colors: [
        amountsProvider.amounts[index].color,
        amountsProvider.amounts[index].color.withAlpha(0x55),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> getBarGroups(Map<String, double> exchangeAmounts) {
    final amounts = amountsProvider.amounts
        .where((element) => exchangeAmounts.containsKey(element.currency))
        .toList();
    return List<BarChartGroupData>.generate(
        amounts.length,
        (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: exchangeAmounts[amounts[index].currency]!,
                  gradient: getBarsGradient(index),
                )
              ],
              showingTooltipIndicators: [0],
            ));
  }
}
