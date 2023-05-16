class ExchangeRate {
  int? id;
  final String date;
  final String currency;
  final double rate;

  ExchangeRate(
    this.currency,
    this.rate,
    this.date,
  );

  toMap() {
    return {
      'currency': currency,
      'rate': rate,
      'date': date,
    };
  }
}
