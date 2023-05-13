import 'package:flutter/material.dart';
import 'package:touristic_wallet/view/common/total_amount_indicator.dart';
import 'package:touristic_wallet/view/statistics/bar_chart.dart';
import 'pie_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  final bool isShowingMainData = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          flexibleSpace: const TotalAmountIndicator(),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bar_chart)),
              Tab(icon: Icon(Icons.pie_chart)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StatisticsBarChart(),
            StatisticsPieChart()
          ],
        ),
      ),
    );
  }
}
