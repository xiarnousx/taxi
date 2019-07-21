import 'package:flutter/material.dart';

class TaxiBorderBottom {
  static BoxDecoration get({@required Color color = Colors.redAccent}) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: color,
          width: 2.0,
        ),
      ),
    );
  }
}
