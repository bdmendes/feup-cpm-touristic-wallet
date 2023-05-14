import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:touristic_wallet/provider/database_provider.dart';

import '../model/exchange_rate.dart';

import 'package:http/http.dart' as http;

class ExchangeRatesProvider extends DatabaseProvider {
  ExchangeRatesProvider()
      : super(
            'exchange_rates.db',
            '''CREATE TABLE exchange_rates '''
                '''(id INTEGER PRIMARY KEY, '''
                '''from_currency TEXT, '''
                '''to_currency TEXT, '''
                '''date TEXT, '''
                '''rate REAL)''');

  static const _apiKey = '2fdb9618804b6ba2dd3e5b62';

  final List<ExchangeRate> _cachedExchangeRates = [];

  Future<ExchangeRate?> getExchangeRate(
      String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) {
      return ExchangeRate(
          fromCurrency, toCurrency, 1, DateTime.now().toIso8601String());
    }

    final cachedExchangeRate = _cachedExchangeRates.firstWhere(
        (element) =>
            element.fromCurrency == fromCurrency &&
            element.toCurrency == toCurrency,
        orElse: () => ExchangeRate(
            fromCurrency, toCurrency, 0, DateTime.now().toIso8601String()));
    if (cachedExchangeRate.rate != 0) {
      return cachedExchangeRate;
    }

    final url = Uri.parse(
        "https://v6.exchangerate-api.com/v6/$_apiKey/latest/$fromCurrency");
    return http.get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load exchange rate');
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final rate = data['conversion_rates']?[toCurrency];
      final date = data['time_last_update_utc'];
      if (rate == null || date == null) {
        return null;
      }
      final exchangeRate = ExchangeRate(fromCurrency, toCurrency, rate, date);
      _cachedExchangeRates.remove(cachedExchangeRate);
      _cachedExchangeRates.add(exchangeRate);
      _saveToDatabase(exchangeRate);
      return exchangeRate;
    }).catchError((error) async {
      return _getFromDatabase(fromCurrency, toCurrency);
    });
  }

  Future<ExchangeRate?> _getFromDatabase(
      String fromCurrency, String toCurrency) {
    return database.query(
      'exchange_rates',
      where: 'from_currency = ? AND to_currency = ?',
      whereArgs: [fromCurrency, toCurrency],
    ).then((value) {
      if (value.isEmpty) {
        return null;
      }
      return ExchangeRate(
        value[0]['from_currency'],
        value[0]['to_currency'],
        value[0]['rate'],
        value[0]['date'],
      );
    });
  }

  Future<void> _saveToDatabase(ExchangeRate exchangeRate) async {
    await database.delete(
      'exchange_rates',
      where: 'from_currency = ? AND to_currency = ?',
      whereArgs: [exchangeRate.fromCurrency, exchangeRate.toCurrency],
    );
    return database.insert(
      'exchange_rates',
      exchangeRate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  String? getLastUpdateTime() {
    if (_cachedExchangeRates.isEmpty) {
      return null;
    }
    final dateComponents = _cachedExchangeRates[0].date.split(" ");
    return dateComponents.sublist(0, dateComponents.length - 2).join(" ");
  }
}
