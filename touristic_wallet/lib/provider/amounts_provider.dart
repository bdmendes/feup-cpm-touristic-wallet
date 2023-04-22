import 'dart:collection';

import 'package:flutter/material.dart';

import '../model/amount.dart';

class AmountsProvider extends ChangeNotifier {
  List<Amount> _amounts = [];

  UnmodifiableListView<Amount> get amounts => UnmodifiableListView(_amounts);

  Future<void> loadAmountsFromStorage() async {
    // TODO: Get from the database
    final amounts = await Future.delayed(
      const Duration(seconds: 1),
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

  void replaceAmount(Amount oldAmount, Amount newAmount) {
    for (int i = 0; i < _amounts.length; i++) {
      if (_amounts[i] == oldAmount) {
        _amounts.removeAt(i);
        _amounts.insert(i, newAmount);
        notifyListeners();
        break;
      }
    }
  }
}
