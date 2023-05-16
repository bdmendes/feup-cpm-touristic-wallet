import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/view/statistics/bar_chart.dart';
import '../../provider/amounts_provider.dart';
import 'pie_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AmountsProvider>(
        builder: (context, amountsProvider, child) {
          return amountsProvider.amounts.isNotEmpty ? const DefaultTabController(
              length: 2,
              child: Column(children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.bar_chart)),
                    Tab(icon: Icon(Icons.pie_chart)),
                  ],
                ),
                Expanded(
                    child: TabBarView(
                      children: [StatisticsBarChart(), StatisticsPieChart()],
                    ))
              ])) : const Center(child: Text('No data to display'));
        });
  }
}
