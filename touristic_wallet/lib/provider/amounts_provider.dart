import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:touristic_wallet/provider/database_provider.dart';

import '../model/amount.dart';
import 'exchange_rates_provider.dart';

class AmountsProvider extends DatabaseProvider {
  AmountsProvider()
      : super('amounts.db',
            'CREATE TABLE amounts (id INTEGER PRIMARY KEY, amount REAL, currency TEXT)');

  List<Amount> _amounts = [];

  UnmodifiableListView<Amount> get amounts => UnmodifiableListView(_amounts);

  Future<void> loadAmountsFromStorage() async {
    await initDatabase();

    final amountsMap = await database.query('amounts');
    final amounts = List.generate(
      amountsMap.length,
      (index) => Amount(
        amountsMap[index]['amount'],
        amountsMap[index]['currency'],
        id: amountsMap[index]['id'],
      ),
    );

    _amounts = amounts;
    notifyListeners();
  }

  Future<void> addAmount(Amount amount) async {
    final id = await database.insert(
      'amounts',
      amount.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    amount.id = id;

    _amounts.add(amount);
    notifyListeners();
  }

  Future<void> removeAmount(Amount amount) async {
    await database.delete(
      'amounts',
      where: 'id = ?',
      whereArgs: [amount.id],
    );

    _amounts.remove(amount);
    notifyListeners();
  }

  Future<void> replaceAmount(Amount oldAmount, Amount newAmount) async {
    for (int i = 0; i < _amounts.length; i++) {
      if (_amounts[i] == oldAmount) {
        await database.update(
          'amounts',
          newAmount.toMap(),
          where: 'id = ?',
          whereArgs: [oldAmount.id],
        );

        _amounts.removeAt(i);
        _amounts.insert(i, newAmount);

        notifyListeners();
        break;
      }
    }
  }

  Future<double> getTotalAmount(
      String currency, ExchangeRatesProvider exchangeRatesProvider) async {
    var totalAmount = 0.0;

    for (final amount in _amounts) {
      if (amount.currency == currency) {
        totalAmount += amount.value;
        continue;
      }

      final exchangeRate = await exchangeRatesProvider.getExchangeRate(
          amount.currency, currency);
      if (exchangeRate != null) {
        totalAmount += amount.value * exchangeRate.rate;
      }
    }

    return totalAmount;
  }
}
