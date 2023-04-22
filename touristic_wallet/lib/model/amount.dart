const currencies = ['USD', 'EUR', 'GBP', 'CHF', 'JPY', 'CNY', 'RUB'];

class Amount {
  int? id;
  final double value;
  final String currency;

  Amount(this.value, String currency, {this.id})
      : currency = currency.trim().toUpperCase(),
        assert(value >= 0);

  Map<String, dynamic> toMap() {
    return {
      'amount': value,
      'currency': currency,
    };
  }
}
