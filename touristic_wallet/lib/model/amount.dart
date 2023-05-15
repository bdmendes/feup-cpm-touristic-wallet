import 'dart:math';
import 'dart:ui';

class Amount {
  int? id;
  final double value;
  final String currency;
  Color color;

  Amount(this.value, String currency, {this.id})
      : currency = currency.trim().toUpperCase(),
        color = Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
        assert(value >= 0);

  Map<String, dynamic> toMap() {
    return {
      'amount': value,
      'currency': currency,
    };
  }
}
