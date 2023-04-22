class Amount {
  int? id;
  double value;
  final String currency;

  Amount(this.value, String currency, {this.id})
      : currency = currency.trim().toUpperCase(),
        assert(value >= 0);
}