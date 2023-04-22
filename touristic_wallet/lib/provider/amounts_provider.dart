import 'dart:collection';

import 'package:flutter/material.dart';

import '../model/amount.dart';

class AmountsProvider extends ChangeNotifier {
  List<Amount> _amounts = [];

  UnmodifiableListView<Amount> get amounts => UnmodifiableListView(_amounts);

  Future<void> loadAmountsFromStorage() async {
    // TODO: Get from the database
    final amounts = await Future.delayed(
      const Duration(seconds: 3),
      () => [
        Amount(10, 'EUR'),
        Amount(20, 'EUR'),
      ],
    );
    _amounts = amounts;
    notifyListeners();
  }

  void addAmount(Amount amount) {
    _amounts.add(amount);
    notifyListeners();
  }

  void removeAmount(Amount amount) {
    _amounts.remove(amount);
    notifyListeners();
  }

  void editAmountValue(Amount amount, double newValue) {
    amount.value = newValue;
    notifyListeners();
  }
}