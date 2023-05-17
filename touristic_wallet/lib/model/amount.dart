import 'dart:math';

import 'package:flutter/cupertino.dart';

class Amount {
  int? id;
  final double value;
  final String currency;
  Color color;

  Amount(this.value, String currency, {this.id})
      : currency = currency.trim().toUpperCase(),
        color = getColor(currency),
        assert(value >= 0);

  static Color getColor(String currency) {
    Random random = Random(currency.hashCode);
    final color = HSVColor.fromAHSV(1, random.nextDouble() * 360, 0.3 + 0.7 * random.nextDouble(), 0.8);

    return color.toColor();
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': value,
      'currency': currency,
    };
  }
}
