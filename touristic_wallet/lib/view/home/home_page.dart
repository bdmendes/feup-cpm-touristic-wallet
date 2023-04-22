import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/provider/amounts_provider.dart';
import 'amount_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AmountsProvider>(
      builder: (context, amountsProvider, child) {
        return ListView.builder(
          itemCount: amountsProvider.amounts.length,
          itemBuilder: (context, index) {
            final amount = amountsProvider.amounts[index];
            return AmountCard(amount: amount);
          },
        );
      },
    );
  }
}