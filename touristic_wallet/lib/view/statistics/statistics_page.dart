import 'package:flutter/material.dart';
import 'package:touristic_wallet/view/common/total_amount_indicator.dart';
import 'package:touristic_wallet/view/statistics/bar_chart.dart';
import 'pie_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  final bool isShowingMainData = false;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Column(
      children: [
        const TotalAmountIndicator(),
        Expanded(child: PageView(
              controller: controller,
              children: const <Widget>[
                StatisticsBarChart(),
                StatisticsPieChart()
              ],
            )
        ),
      ],
    );
  }
}
