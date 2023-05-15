import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/provider/currencies_provider.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';

import '../../model/currency.dart';
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
    return Consumer3<AmountsProvider, ExchangeRatesProvider, CurrenciesProvider>(
      builder: (context, amountsProvider, exchangeRatesProvider, currenciesProvider, child) {
        final lastUpdate = exchangeRatesProvider.getLastUpdateTime();
        if (amountsProvider.amounts.isEmpty) {
          return const Text(
            'Total: 0',
            style: TextStyle(fontSize: 20),
          );
        }

        return FutureBuilder(
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                      items: snapshot.data?[1]!.map<DropdownMenuItem<String>>((Currency currency) {
                        return DropdownMenuItem<String>(
                          value: currency.code,
                          child: Text(currency.code, style: const TextStyle(fontSize: 20)),
                        );
                      }).toList(),
                    ),
                    Text(
                      'Total: ${snapshot.data?[0]} ${amountsProvider.currency}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text("Last update: $lastUpdate"),
                  ],
                );
              }
                return const CircularProgressIndicator();
            },
            future: Future.wait([amountsProvider.getTotalAmount(exchangeRatesProvider), currenciesProvider.getCurrencies()]));
      },
    );
  }
}
