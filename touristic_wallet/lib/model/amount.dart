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
    final color = HSVColor.fromAHSV(1, 360 / 26 * (currency.codeUnitAt(0) - 65),
        0.5 + 0.5 * cos(360 / 26 * (currency.codeUnitAt(1) - 65)), 1);

    return color.toColor();
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': value,
      'currency': currency,
    };
  }
}
