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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bar_chart)),
              Tab(icon: Icon(Icons.pie_chart)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatisticsBarChart(),
            StatisticsPieChart()
          ],
        ),
      ),
    );
  }
}
