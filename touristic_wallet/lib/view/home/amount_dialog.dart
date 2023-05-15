import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/amount.dart';
import '../../model/currency.dart';
import '../../provider/amounts_provider.dart';
import '../../provider/currencies_provider.dart';

class AmountDialog extends StatefulWidget {
  const AmountDialog({super.key, this.savedAmount});

  final Amount? savedAmount;

  @override
  State<StatefulWidget> createState() {
    return AmountDialogState();
  }
}

class AmountDialogState extends State<AmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valueController = TextEditingController();
  String? _currency;

  @override
  Widget build(BuildContext context) {
    if (widget.savedAmount != null) {
      if (_valueController.text.isEmpty) {
        _valueController.text = widget.savedAmount!.value.toString();
      }
      _currency ??= widget.savedAmount!.currency;
    }
    final amountsProvider =
        Provider.of<AmountsProvider>(context, listen: false);
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: false);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.savedAmount == null ? 'Add amount' : 'Edit amount',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Invalid value';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: _valueController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Value',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                          width: 100,
                          child: FutureBuilder(
                              future: currenciesProvider.getCurrencies(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                  return DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Invalid currency';
                                      }
                                      return null;
                                    },
                                    value: _currency,
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<String>>((Currency currency) {
                                      return DropdownMenuItem<String>(
                                        value: currency.code,
                                        child: Text(currency.code),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _currency = value;
                                      });
                                    },
                                  );
                                }
                                return const SizedBox(
                                    width: 100,
                                    child: Center(
                                        child: CircularProgressIndicator())
                                );}
                          )),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            if (widget.savedAmount == null) {
                              final amount = Amount(
                                  double.parse(_valueController.text),
                                  _currency!);
                              amountsProvider.addAmount(amount);
                              Navigator.pop(context);
                              return;
                            }

                            final amount = Amount(
                                double.parse(_valueController.text), _currency!,
                                id: widget.savedAmount!.id);
                            amountsProvider.replaceAmount(
                                widget.savedAmount!, amount);
                            Navigator.pop(context);
                          },
                          child: const Text('Save')),
                    ],
                  )
                ],
              )),
        ));
  }
}
