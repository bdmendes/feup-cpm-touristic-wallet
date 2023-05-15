import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/provider/currencies_provider.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey _dropdownButtonKey = GlobalKey<DropdownButton2State>();

  void openDropdown() {
    _dropdownButtonKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              return;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicator =
        Consumer3<AmountsProvider, ExchangeRatesProvider, CurrenciesProvider>(
      builder: (context, amountsProvider, exchangeRatesProvider,
          currenciesProvider, child) {
        if (amountsProvider.amounts.isEmpty) {
          return const Column(children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'No money yet. Add some!',
              style: TextStyle(fontSize: 25),
            ),
          ]);
        }

        return FutureBuilder(
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              final lastUpdate =
                  exchangeRatesProvider.getLastUpdateTime() ?? "Never";
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data![0] < 0) {
                  return const Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text('Total amount not available',
                          style: TextStyle(fontSize: 18)),
                      Text(
                        'Connect to the internet or remove newly added currencies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Flexible(child:GestureDetector(
                          onTap: () {
                            openDropdown();
                          },
                          child: Text(
                            snapshot.data![0].toStringAsFixed(2),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 40),
                          ),
                        )),
                        const SizedBox(width: 10),
                        DropdownButton2<String>(
                          key: _dropdownButtonKey,
                          alignment: Alignment.centerRight,
                          items: snapshot.data?[1]!
                              .map<DropdownMenuItem<String>>(
                                  (Currency currency) {
                            return DropdownMenuItem<String>(
                              value: currency.code,
                              child: Text(currency.code,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          value: amountsProvider.currency,
                          onChanged: (String? newValue) {
                            setState(() {
                              amountsProvider.currency = newValue!;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 400,
                            width: 100,
                          ),
                          underline: Container(color: Colors.transparent),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.all(4),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: 'Search',
                                  hintStyle: const TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .contains(searchValue.toUpperCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _textEditingController.clear();
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Text("Last update: $lastUpdate"),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
            future: Future.wait([
              amountsProvider.getTotalAmount(exchangeRatesProvider),
              currenciesProvider.getCurrencies()
            ]));
      },
    );

    return RefreshIndicator(
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 120,
                child: Center(
                  child: indicator,
                ),
              ),
            ]),
        onRefresh: () async {
          Provider.of<AmountsProvider>(context, listen: false).getTotalAmount(
              Provider.of<ExchangeRatesProvider>(context, listen: false),
              notify: true);
        });
  }
}
