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
                '''currency TEXT, '''
                '''date TEXT, '''
                '''rate REAL)''');

  static const _apiKey = 'b25dbffc483049968343b355165be250';

  final List<ExchangeRate> _cachedExchangeRates = [];

  Future<double?> getExchangeRate(
      String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) {
      return 1;
    }

    final cachedFromCurrencyExchangeRate = _cachedExchangeRates.firstWhere(
        (element) => element.currency == fromCurrency && element.rate != 0,
        orElse: () => ExchangeRate(fromCurrency, 0, DateTime.now().toString()));

    final cachedToCurrencyExchangeRate = _cachedExchangeRates.firstWhere(
        (element) => element.currency == toCurrency && element.rate != 0,
        orElse: () => ExchangeRate(toCurrency, 0, DateTime.now().toString()));

    if (cachedFromCurrencyExchangeRate.rate != 0 &&
        cachedToCurrencyExchangeRate.rate != 0) {
      return cachedToCurrencyExchangeRate.rate /
          cachedFromCurrencyExchangeRate.rate;
    }

    final url = Uri.parse(
        "https://api.currencyfreaks.com/v2.0/rates/latest?apikey=$_apiKey");
    return http.get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load exchange rate');
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      for (final entry in data['rates'].entries) {
        final rate = double.tryParse(entry.value) ?? 0;
        if (rate == 0) {
          continue;
        }

        final currency = entry.key;
        _cachedExchangeRates
            .removeWhere((exchangeRate) => exchangeRate.currency == currency);
        _cachedExchangeRates.add(ExchangeRate(currency, rate, data['date']));
      }

      _saveToDatabase(_cachedExchangeRates);

      final fromCurrencyRate = _cachedExchangeRates.firstWhere(
          (exchangeRate) => exchangeRate.currency == fromCurrency,
          orElse: () =>
              ExchangeRate(fromCurrency, 0, DateTime.now().toString()));
      final toCurrencyRate = _cachedExchangeRates.firstWhere(
          (exchangeRate) => exchangeRate.currency == toCurrency,
          orElse: () => ExchangeRate(toCurrency, 0, DateTime.now().toString()));
      if (fromCurrencyRate.rate == 0 || toCurrencyRate.rate == 0) {
        return null;
      }

      return toCurrencyRate.rate / fromCurrencyRate.rate;
    }).catchError((error) async {
      final fromCurrencyExchangeRate = await _getFromDatabase(fromCurrency);
      final toCurrencyExchangeRate = await _getFromDatabase(toCurrency);
      if (fromCurrencyExchangeRate != null) {
        _cachedExchangeRates.removeWhere(
            (exchangeRate) => exchangeRate.currency == fromCurrency);
        _cachedExchangeRates.add(fromCurrencyExchangeRate);
      }

      if (toCurrencyExchangeRate != null) {
        _cachedExchangeRates
            .removeWhere((exchangeRate) => exchangeRate.currency == toCurrency);
        _cachedExchangeRates.add(toCurrencyExchangeRate);
      }

      return toCurrencyExchangeRate!.rate / fromCurrencyExchangeRate!.rate;
    });
  }

  Future<ExchangeRate?> _getFromDatabase(String currency) async {
    final exchangeRateData = await database.query(
      'exchange_rates',
      where: 'currency = ?',
      whereArgs: [currency],
    );

    if (exchangeRateData.isEmpty) {
      return null;
    }
    return ExchangeRate(
      exchangeRateData[0]['currency'],
      exchangeRateData[0]['rate'],
      exchangeRateData[0]['date'],
    );
  }

  Future<void> _saveToDatabase(List<ExchangeRate> exchangeRates) async {
    await database.delete('exchange_rates');

    for (final exchangeRate in exchangeRates) {
      await database.insert(
        'exchange_rates',
        exchangeRate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  String? getLastUpdateTime() {
    if (_cachedExchangeRates.isEmpty) {
      return null;
    }

    final dateComponents = _cachedExchangeRates[0].date.split(":");
    return dateComponents.sublist(0, dateComponents.length - 1).join(":");
  }
}
