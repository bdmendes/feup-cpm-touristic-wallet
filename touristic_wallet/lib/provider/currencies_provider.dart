import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:touristic_wallet/provider/database_provider.dart';

import '../model/currency.dart';

import 'package:http/http.dart' as http;

class CurrenciesProvider extends DatabaseProvider {
  CurrenciesProvider()
      : super(
      'currencies.db',
      '''CREATE TABLE currencies '''
          '''(id INTEGER PRIMARY KEY, '''
          '''code TEXT, '''
          '''name TEXT, '''
          '''type TEXT, '''
          '''icon TEXT)''');

  final List<Currency> _cachedCurrencies = [];

  Future<List<Currency>?> getCurrencies() async {
    if (_cachedCurrencies.isNotEmpty) {
      return _cachedCurrencies;
    }

    return await getCurrenciesFromAPI();
  }

  Future<List<Currency>?> getCurrenciesFromAPI() async {
    final url = Uri.parse(
        "https://api.currencyfreaks.com/v2.0/supported-currencies");
    return http.get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load currencies');
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final currenciesMap = data['supportedCurrenciesMap'] as Map?;
      if (currenciesMap == null || currenciesMap.isEmpty) {
        return null;
      }
      final currencies = currenciesMap.entries
          .where((c) => c.value['countryCode'] != 'Crypto')   // filter cryptocurrencies
          .map((c) =>
          Currency(c.key, c.value['currencyName'], c.value['countryCode'],
              c.value['icon']))
          .toList();
      currencies.sort((a, b) => a.code.compareTo(b.code));
      _cachedCurrencies.clear();
      _cachedCurrencies.addAll(currencies);
      _saveToDatabase(currencies);

      return currencies;
    }).catchError((error) async {
      return getCurrenciesFromDatabase();
    });
  }

  Future<List<Currency>?> getCurrenciesFromDatabase() async {
    return await database.query('currencies').then((value) {
      if (value.isEmpty) {
        return null;
      }
      final currencies = List.generate(value.length, (index) =>
        Currency(value[index]['code'], value[index]['name'], value[index]['type'], value[index]['icon'])
      );
      _cachedCurrencies.clear();
      _cachedCurrencies.addAll(currencies);
      return currencies;
    });
  }

  Future<void> _saveToDatabase(List<Currency> currencies) async {
    await database.delete('currencies');

    for (final currency in currencies) {
      await database.insert(
        'currencies',
        currency.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Currency findCurrency(String code) {
  //   return _cachedCurrencies.firstWhere((element) => element.code == code);
  // }
}