import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/model/amount.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    final indicator = Consumer2<AmountsProvider, ExchangeRatesProvider>(
      builder: (context, amountsProvider, exchangeRatesProvider, child) {
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
            builder: (context, snapshot) {
              final lastUpdate =
                  exchangeRatesProvider.getLastUpdateTime() ?? "Never";
              if (snapshot.hasData) {
                if (snapshot.data! < 0) {
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
                        GestureDetector(
                          onTap: () {
                            openDropdown();
                          },
                          child: Text(
                            snapshot.data!.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 45),
                          ),
                        ),
                        const SizedBox(width: 5),
                        DropdownButton2<String>(
                          key: _dropdownButtonKey,
                          alignment: Alignment.centerRight,
                          items: currencies
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
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
                      ],
                    ),
                    Text("Last update: $lastUpdate"),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
            future: amountsProvider.getTotalAmount(exchangeRatesProvider));
      },
    );

    return SizedBox(
      height: 130,
      child: Center(
        child: indicator,
      ),
    );
  }
}
