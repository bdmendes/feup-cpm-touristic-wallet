import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/model/amount.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';

import '../../provider/amounts_provider.dart';

class TotalAmountIndicator extends StatefulWidget {
  const TotalAmountIndicator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TotalAmountIndicatorState();
  }
}

class TotalAmountIndicatorState extends State<TotalAmountIndicator> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AmountsProvider, ExchangeRatesProvider>(
      builder: (context, amountsProvider, exchangeRatesProvider, child) {
        final lastUpdate = exchangeRatesProvider.getLastUpdateTime();
        if (amountsProvider.amounts.isEmpty) {
          return const Text(
            'Total: 0',
            style: TextStyle(fontSize: 20),
          );
        }

        return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    DropdownButton<String>(
                      value: amountsProvider.currency,
                      onChanged: (String? newValue) {
                        setState(() {
                          amountsProvider.currency = newValue!;
                        });
                      },
                      items: currencies
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 20)),
                        );
                      }).toList(),
                    ),
                    Text(
                      'Total: ${snapshot.data} ${amountsProvider.currency}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text("Last update: $lastUpdate"),
                  ],
                );
              } else {
                return const Text(
                  'Total: Unknown',
                  style: TextStyle(fontSize: 20),
                );
              }
            },
            future: amountsProvider.getTotalAmount(exchangeRatesProvider));
      },
    );
  }
}
