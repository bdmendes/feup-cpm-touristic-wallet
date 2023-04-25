class ExchangeRate {
  int? id;
  final String date;
  final String fromCurrency;
  final String toCurrency;
  final double rate;

  ExchangeRate(
    this.fromCurrency,
    this.toCurrency,
    this.rate,
    this.date,
  );

  toMap() {
    return {
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'rate': rate,
      'date': date,
    };
  }
}
