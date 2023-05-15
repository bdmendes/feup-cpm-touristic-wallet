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
          padding: const EdgeInsets.only(bottom: 80),
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
