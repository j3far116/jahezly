import 'package:flutter/material.dart';

import 'icons.dart';

class J3Price extends StatelessWidget {
  const J3Price(this.value, {super.key, this.iconSize = 18, this.style, this.withIcon = true});

  final double value;
  final TextStyle? style;
  final bool? withIcon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${price()} ', style: style),
        (withIcon!) ? Icon(J3Icons.riyal, size: iconSize) : Container(),
      ],
    );
  }

  String price() {
    // .. تقريب الأعداد العشرية
    return value.toStringAsFixed(2).replaceAll(RegExp(r'\.?00+$'), '');
  }
}

double doublePrice(String value) {
  // .. Convert String Number To Double
  return double.parse(value);
}
